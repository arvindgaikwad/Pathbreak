extends Node2D

var ResultPopupScene = preload("res://scenes/game/result_popup.tscn")

@onready var board = $BoardPivot/Board
@onready var hud = $HUD

var current_level_idx: int = 0
var level_start_msec: int = 0
var mistake_count: int = 0
var hints_left: int = 5
var total_pieces: int = 0
var remaining_pieces: int = 0
var level_data_list: Array[PuzzleLevelData] = []

func _ready():
	_load_phase1_levels()
	hud.restart_pressed.connect(_on_restart_pressed)
	hud.hint_pressed.connect(_on_hint_pressed)
	hud.back_pressed.connect(_on_back_pressed)
	
	current_level_idx = SaveManager.current_level
	hints_left = SaveManager.hint_count
	
	load_level(current_level_idx)

func _load_phase1_levels():
	level_data_list.clear()
	for i in range(1, 6):
		var res_path = "res://data/levels/level_%d.tres" % i
		if ResourceLoader.exists(res_path):
			var lvl = load(res_path) as PuzzleLevelData
			if lvl:
				level_data_list.append(lvl)
				continue
				
		# Fallback to json definition if tres not compiled yet
		var json_path = "res://data/level%d.json" % i
		if FileAccess.file_exists(json_path):
			var file = FileAccess.open(json_path, FileAccess.READ)
			var json = JSON.new()
			if json.parse(file.get_as_text()) == OK:
				var d = json.data
				var lvl = PuzzleLevelData.new()
				lvl.level_id = i
				lvl.difficulty = d.get("difficulty", "Normal")
				lvl.board_size = Vector2i(d.get("width", 8), d.get("height", 8))
				lvl.starting_lives = d.get("lives", 3)
				lvl.pieces = []
				var pid = 1
				for p in d.get("pieces", []):
					var p_data = PuzzlePieceData.create(pid, p.get("cells", []), Vector2i(p.get("direction")[0], p.get("direction")[1]))
					lvl.pieces.append(p_data)
					pid += 1
				level_data_list.append(lvl)

func load_level(idx: int):
	if level_data_list.is_empty():
		return
		
	current_level_idx = posmod(idx, level_data_list.size())
	SaveManager.current_level = current_level_idx
	SaveManager.save_game()
	
	var lvl_data = level_data_list[current_level_idx]
	mistake_count = 0
	level_start_msec = Time.get_ticks_msec()
	
	board.setup_level(lvl_data)
	total_pieces = lvl_data.pieces.size()
	remaining_pieces = total_pieces
	
	for piece in board.pieces:
		piece.piece_tapped.connect(_on_piece_tapped)
		
	hud.update_hud(lvl_data.level_id, lvl_data.difficulty, mistake_count, hints_left)
	board.update_idle_pulses()

func _on_piece_tapped(piece: PuzzlePiece):
	if piece.is_removed or piece.is_animating:
		return
		
	if board.can_piece_escape(piece):
		AudioManager.play_move_sound()
		board.remove_piece_occupancy(piece)
		piece.animate_successful_escape()
		remaining_pieces -= 1
		
		get_tree().create_timer(0.35).timeout.connect(func():
			board.update_idle_pulses()
		)
		
		if remaining_pieces <= 0:
			_on_level_completed()
	else:
		AudioManager.play_blocked_sound()
		mistake_count += 1
		hud.update_hud(level_data_list[current_level_idx].level_id, level_data_list[current_level_idx].difficulty, mistake_count, hints_left)
		piece.animate_blocked_tap()

func _on_level_completed():
	AudioManager.play_win_sound()
	var elapsed_sec = (Time.get_ticks_msec() - level_start_msec) / 1000.0
	
	var popup = ResultPopupScene.instantiate()
	add_child(popup)
	popup.show_popup(current_level_idx + 1, elapsed_sec, mistake_count)
	
	popup.next_pressed.connect(func():
		popup.queue_free()
		load_level(current_level_idx + 1)
	)
	popup.replay_pressed.connect(func():
		popup.queue_free()
		load_level(current_level_idx)
	)

func _on_restart_pressed():
	load_level(current_level_idx)

func _on_hint_pressed():
	if hints_left > 0:
		hints_left -= 1
		SaveManager.hint_count = hints_left
		SaveManager.save_game()
		hud.update_hud(level_data_list[current_level_idx].level_id, level_data_list[current_level_idx].difficulty, mistake_count, hints_left)
		
		for p in board.pieces:
			if is_instance_valid(p) and not p.is_removed:
				if board.can_piece_escape(p):
					var tween = create_tween()
					tween.tween_property(p.line, "default_color", Color("#3978F6"), 0.2)
					tween.tween_property(p.line, "default_color", Color("#172033"), 0.2)
					tween.set_loops(3)
					break

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
