extends Node2D

var ResultPopupScene = preload("res://scenes/game/result_popup.tscn")

@onready var board = $BoardPivot/Board
@onready var hud = $HUD

var current_level_idx: int = 0
var level_start_msec: int = 0
var mistake_count: int = 0
var hints_left: int = 5
var lives_left: int = 3
var total_pieces: int = 0
var remaining_pieces: int = 0
var input_locked: bool = false
var level_data_list: Array[PuzzleLevelData] = []

func _ready() -> void:
	_load_levels()
	hud.restart_pressed.connect(_on_restart_pressed)
	hud.hint_pressed.connect(_on_hint_pressed)
	hud.back_pressed.connect(_on_back_pressed)

	if level_data_list.is_empty():
		push_error("No Pathbreak levels could be loaded.")
		return

	current_level_idx = clampi(SaveManager.current_level, 0, level_data_list.size() - 1)
	hints_left = SaveManager.hint_count
	load_level(current_level_idx)

func _load_levels() -> void:
	level_data_list.clear()
	for level_number in range(1, 11):
		var level := _load_level_resource(level_number)
		if level != null:
			level_data_list.append(level)

func _load_level_resource(level_number: int) -> PuzzleLevelData:
	var resource_path := "res://data/levels/level_%d.tres" % level_number
	if ResourceLoader.exists(resource_path):
		var resource_level := load(resource_path) as PuzzleLevelData
		if resource_level != null:
			return resource_level

	var json_path := "res://data/level%d.json" % level_number
	if not FileAccess.file_exists(json_path):
		push_warning("Missing level definition: %s" % json_path)
		return null

	var file := FileAccess.open(json_path, FileAccess.READ)
	if file == null:
		push_warning("Could not open level definition: %s" % json_path)
		return null

	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Invalid level JSON: %s" % json_path)
		return null

	var data: Dictionary = parsed
	var level := PuzzleLevelData.new()
	level.level_id = level_number
	level.difficulty = str(data.get("difficulty", _difficulty_for_level(level_number)))
	level.board_size = Vector2i(int(data.get("width", 8)), int(data.get("height", 8)))
	level.starting_lives = int(data.get("lives", 3))

	var piece_id := 1
	for raw_piece in data.get("pieces", []):
		if not raw_piece is Dictionary:
			continue
		var direction_data: Array = raw_piece.get("direction", [1, 0])
		if direction_data.size() < 2:
			continue
		var piece := PuzzlePieceData.create(
			piece_id,
			raw_piece.get("cells", []),
			Vector2i(int(direction_data[0]), int(direction_data[1]))
		)
		if not piece.cells.is_empty():
			level.pieces.append(piece)
			piece_id += 1

	return level

func _difficulty_for_level(level_number: int) -> String:
	if level_number <= 3:
		return "Easy"
	if level_number <= 7:
		return "Normal"
	return "Hard"

func load_level(index: int) -> void:
	if level_data_list.is_empty():
		return

	input_locked = false
	current_level_idx = clampi(index, 0, level_data_list.size() - 1)
	SaveManager.current_level = current_level_idx
	SaveManager.save_game()

	var level_data := level_data_list[current_level_idx]
	mistake_count = 0
	lives_left = maxi(level_data.starting_lives, 1)
	level_start_msec = Time.get_ticks_msec()

	board.setup_level(level_data)
	total_pieces = level_data.pieces.size()
	remaining_pieces = total_pieces

	for piece in board.pieces:
		piece.piece_tapped.connect(_on_piece_tapped)

	hud.update_hud(level_data.level_id, level_data.difficulty, lives_left, hints_left)
	board.update_idle_pulses()

func _on_piece_tapped(piece: PuzzlePiece) -> void:
	if input_locked or piece.is_removed or piece.is_animating:
		return

	if board.can_piece_escape(piece):
		AudioManager.play_move_sound()
		board.remove_piece_occupancy(piece)
		piece.animate_successful_escape()
		remaining_pieces -= 1

		get_tree().create_timer(0.35).timeout.connect(func() -> void:
			if not input_locked:
				board.update_idle_pulses()
		)

		if remaining_pieces <= 0:
			input_locked = true
			get_tree().create_timer(0.28).timeout.connect(_on_level_completed)
	else:
		AudioManager.play_blocked_sound()
		mistake_count += 1
		lives_left = maxi(lives_left - 1, 0)
		hud.update_hud(level_data_list[current_level_idx].level_id, level_data_list[current_level_idx].difficulty, lives_left, hints_left)
		piece.animate_blocked_tap()
		if lives_left <= 0:
			input_locked = true
			get_tree().create_timer(0.45).timeout.connect(func() -> void:
				load_level(current_level_idx)
			)

func _on_level_completed() -> void:
	AudioManager.play_win_sound()
	var elapsed_seconds := (Time.get_ticks_msec() - level_start_msec) / 1000.0
	var stars := _calculate_stars(mistake_count, lives_left)
	var hints_used := maxi(SaveManager.hint_count - hints_left, 0)

	SaveManager.hint_count = hints_left
	SaveManager.record_level_completion(
		current_level_idx,
		stars,
		elapsed_seconds,
		mistake_count,
		level_data_list.size()
	)

	var popup = ResultPopupScene.instantiate()
	add_child(popup)
	popup.show_popup(current_level_idx + 1, elapsed_seconds, mistake_count, hints_used)

	popup.next_pressed.connect(func() -> void:
		popup.queue_free()
		if current_level_idx < level_data_list.size() - 1:
			load_level(current_level_idx + 1)
		else:
			get_tree().change_scene_to_file("res://scenes/LevelSelect.tscn")
	)
	popup.replay_pressed.connect(func() -> void:
		popup.queue_free()
		load_level(current_level_idx)
	)

func _calculate_stars(mistakes: int, remaining_lives: int) -> int:
	if mistakes == 0:
		return 3
	if remaining_lives > 0:
		return 2
	return 1

func _on_restart_pressed() -> void:
	if input_locked:
		return
	load_level(current_level_idx)

func _on_hint_pressed() -> void:
	if input_locked or hints_left <= 0:
		return

	var candidate: PuzzlePiece = null
	for piece in board.pieces:
		if is_instance_valid(piece) and not piece.is_removed and board.can_piece_escape(piece):
			candidate = piece
			break

	if candidate == null:
		return

	hints_left -= 1
	SaveManager.hint_count = hints_left
	SaveManager.save_game()
	hud.update_hud(level_data_list[current_level_idx].level_id, level_data_list[current_level_idx].difficulty, lives_left, hints_left)

	var tween := create_tween()
	tween.tween_property(candidate.line, "default_color", Color("#3978F6"), 0.2)
	tween.tween_property(candidate.line, "default_color", Color("#172033"), 0.2)
	tween.set_loops(3)

func _on_back_pressed() -> void:
	SaveManager.current_level = current_level_idx
	SaveManager.hint_count = hints_left
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
