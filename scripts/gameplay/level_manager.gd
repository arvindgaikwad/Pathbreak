extends Control

var ResultPopupScene: PackedScene = preload("res://scenes/game/result_popup.tscn")
var FailScreenScene: PackedScene = preload("res://scenes/GameOverScreen.tscn")
var PauseMenuScene: PackedScene = preload("res://scenes/game/pause_menu.tscn")
var HintRefillPopupScene: PackedScene = preload("res://scenes/game/hint_refill_popup.tscn")

@onready var board_pivot: Node2D = $BoardPivot
@onready var board = $BoardPivot/Board
@onready var hud = $HUD

var current_level_idx: int = 0
var level_start_msec: int = 0
var move_count: int = 0
var mistake_count: int = 0
var hints_left: int = 5
var hints_at_level_start: int = 5
var lives_left: int = 3
var total_pieces: int = 0
var remaining_pieces: int = 0
var input_locked: bool = false
var pause_menu: PauseMenu = null
var hint_refill_popup: HintRefillPopup = null
var level_data_list: Array[PuzzleLevelData] = []

const TOP_RESERVED := 190.0
const BOTTOM_RESERVED := 190.0
const SIDE_MARGIN := 24.0
const MAX_BOARD_SCALE := 1.25
const HINT_REFILL_AMOUNT := 3
const FINISH_GAP_AFTER_ESCAPE := 0.015
const REDUCE_MOTION_RESULT_GAP := 0.040

func _ready() -> void:
	_load_levels()
	board.piece_selected.connect(_on_piece_tapped)
	hud.restart_pressed.connect(_on_restart_pressed)
	hud.hint_pressed.connect(_on_hint_pressed)
	hud.back_pressed.connect(_on_back_pressed)
	hud.settings_pressed.connect(_on_settings_pressed)
	get_viewport().size_changed.connect(_update_layout)

	if level_data_list.is_empty():
		push_error("No Pathbreak levels could be loaded.")
		return

	current_level_idx = clampi(SaveManager.current_level, 0, level_data_list.size() - 1)
	hints_left = SaveManager.hint_count
	load_level(current_level_idx)

func _load_levels() -> void:
	level_data_list.clear()
	for level_number in range(1, 1000):
		var has_resource := ResourceLoader.exists("res://data/levels/level_%d.tres" % level_number)
		var has_json := FileAccess.file_exists("res://data/level%d.json" % level_number)
		if not has_resource and not has_json:
			break
		var level := _load_level_resource(level_number)
		if level == null:
			push_error("Stopped loading the level pack at invalid level %d." % level_number)
			break
		level_data_list.append(level)

func _load_level_resource(level_number: int) -> PuzzleLevelData:
	# JSON is the canonical, diff-friendly production format. Resources remain a temporary fallback.
	var json_path := "res://data/level%d.json" % level_number
	if FileAccess.file_exists(json_path):
		var json_level := _load_json_level(json_path, level_number)
		if json_level != null:
			return json_level

	var resource_path := "res://data/levels/level_%d.tres" % level_number
	if ResourceLoader.exists(resource_path):
		var resource_level := load(resource_path) as PuzzleLevelData
		if resource_level != null and _validate_level(resource_level, resource_path):
			return resource_level

	push_warning("No valid level definition for level %d" % level_number)
	return null

func _load_json_level(json_path: String, level_number: int) -> PuzzleLevelData:
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

	if not _validate_level(level, json_path):
		return null
	return level

func _validate_level(level: PuzzleLevelData, source: String) -> bool:
	var errors := LevelDataValidator.validate(level)
	for error in errors:
		push_warning("%s: %s" % [source, error])
	return errors.is_empty()

func _difficulty_for_level(level_number: int) -> String:
	if level_number <= 3:
		return "Easy"
	if level_number <= 7:
		return "Normal"
	return "Hard"

func load_level(index: int) -> void:
	if level_data_list.is_empty():
		return

	_close_pause_menu(false)
	_close_hint_refill_popup(false)
	input_locked = false
	board.set_input_enabled(true)
	hud.set_controls_enabled(true)
	current_level_idx = clampi(index, 0, level_data_list.size() - 1)
	SaveManager.current_level = current_level_idx
	SaveManager.save_game()

	var level_data := level_data_list[current_level_idx]
	move_count = 0
	mistake_count = 0
	lives_left = maxi(level_data.starting_lives, 1)
	hints_at_level_start = hints_left
	level_start_msec = Time.get_ticks_msec()

	board.setup_level(level_data)
	total_pieces = level_data.pieces.size()
	remaining_pieces = total_pieces
	hud.update_hud(level_data.level_id, level_data.difficulty, lives_left, hints_left)
	var tutorial_active := current_level_idx == 0 and not SaveManager.tutorial_completed
	board.update_assist_pulses(tutorial_active)
	if tutorial_active:
		hud.show_message("Follow the moving light to the arrow", true)
	_update_layout()

func _on_piece_tapped(piece: PuzzlePiece) -> void:
	if input_locked or piece.is_removed or piece.is_animating:
		return

	move_count += 1
	if board.can_piece_escape(piece):
		AudioManager.play_move_sound()
		SettingsManager.play_haptic(&"success")
		board.remove_piece_occupancy(piece)
		var escape_duration := piece.get_escape_animation_duration()
		piece.animate_successful_escape()
		remaining_pieces -= 1

		if remaining_pieces == 1:
			_lock_gameplay()
			get_tree().create_timer(escape_duration + FINISH_GAP_AFTER_ESCAPE).timeout.connect(
				_auto_clear_final_piece
			)
			return

		if remaining_pieces <= 0:
			_lock_gameplay()
			get_tree().create_timer(escape_duration + FINISH_GAP_AFTER_ESCAPE).timeout.connect(
				_on_level_completed
			)
			return

		get_tree().create_timer(escape_duration + 0.06).timeout.connect(func() -> void:
			if not input_locked:
				board.update_assist_pulses(current_level_idx == 0 and not SaveManager.tutorial_completed)
		)
	else:
		AudioManager.play_blocked_sound()
		SettingsManager.play_haptic(&"error")
		mistake_count += 1
		lives_left = maxi(lives_left - 1, 0)
		hud.show_message("That path is blocked")
		hud.update_hud(
			level_data_list[current_level_idx].level_id,
			level_data_list[current_level_idx].difficulty,
			lives_left,
			hints_left
		)
		piece.animate_blocked_tap()
		if lives_left <= 0:
			_lock_gameplay()
			get_tree().create_timer(0.35).timeout.connect(_show_fail_screen)

func _auto_clear_final_piece() -> void:
	if remaining_pieces != 1:
		return

	var final_piece: PuzzlePiece = board.get_only_remaining_piece()
	if final_piece == null:
		push_warning("Expected one remaining path, but the board state was inconsistent.")
		input_locked = false
		board.set_input_enabled(true)
		hud.set_controls_enabled(true)
		return

	if not board.can_piece_escape(final_piece):
		push_warning("The final remaining path could not escape.")
		hud.show_message("The final path is still blocked")
		input_locked = false
		board.set_input_enabled(true)
		hud.set_controls_enabled(true)
		return

	if current_level_idx == 0 and not SaveManager.tutorial_completed:
		hud.show_message("Last path clears itself", true)

	final_piece.play_final_clear_preview()
	var preview_duration := final_piece.get_final_clear_preview_duration()
	get_tree().create_timer(preview_duration).timeout.connect(func() -> void:
		if not is_instance_valid(final_piece) or final_piece.is_removed:
			return
		var final_escape_duration := final_piece.get_escape_animation_duration()
		AudioManager.play_move_sound()
		SettingsManager.play_haptic(&"light")
		board.remove_piece_occupancy(final_piece)
		final_piece.animate_successful_escape()
		remaining_pieces = 0
		get_tree().create_timer(final_escape_duration + FINISH_GAP_AFTER_ESCAPE).timeout.connect(
			_on_level_completed
		)
	)

func _show_fail_screen() -> void:
	var fail_screen = FailScreenScene.instantiate()
	add_child(fail_screen)
	fail_screen.retry_pressed.connect(func() -> void:
		fail_screen.queue_free()
		load_level(current_level_idx)
	)
	fail_screen.menu_pressed.connect(func() -> void:
		SaveManager.current_level = current_level_idx
		SaveManager.hint_count = hints_left
		SaveManager.save_game()
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	)

func _on_level_completed() -> void:
	board.play_completion_settle()
	AudioManager.play_win_sound()
	SettingsManager.play_haptic(&"celebration")
	var elapsed_seconds := (Time.get_ticks_msec() - level_start_msec) / 1000.0
	var stars := _calculate_stars(mistake_count)
	var hints_used := maxi(hints_at_level_start - hints_left, 0)

	SaveManager.hint_count = hints_left
	SaveManager.record_level_completion(
		current_level_idx,
		stars,
		elapsed_seconds,
		move_count,
		mistake_count,
		level_data_list.size()
	)

	var settle_delay: float = (
		REDUCE_MOTION_RESULT_GAP
		if SettingsManager.reduce_motion
		else board.get_completion_settle_duration()
	)
	get_tree().create_timer(settle_delay).timeout.connect(func() -> void:
		_show_result_popup(elapsed_seconds, hints_used)
	)

func _show_result_popup(elapsed_seconds: float, hints_used: int) -> void:
	var popup = ResultPopupScene.instantiate()
	add_child(popup)
	popup.show_popup(
		current_level_idx + 1,
		elapsed_seconds,
		move_count,
		mistake_count,
		hints_used
	)

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

func _calculate_stars(mistakes: int) -> int:
	if mistakes == 0:
		return 3
	if mistakes <= 2:
		return 2
	return 1

func _on_restart_pressed() -> void:
	if input_locked:
		return
	load_level(current_level_idx)

func _on_hint_pressed() -> void:
	if input_locked:
		return

	var free_tutorial_hint := current_level_idx == 0 and not SaveManager.tutorial_completed
	if not free_tutorial_hint and hints_left <= 0:
		_open_hint_refill_popup()
		return

	var candidate: PuzzlePiece = board.get_first_escapable_piece()
	if candidate == null:
		hud.show_message("No path can leave yet")
		return

	if not free_tutorial_hint:
		hints_left -= 1
		SaveManager.hint_count = hints_left
		SaveManager.save_game()
		hud.update_hud(
			level_data_list[current_level_idx].level_id,
			level_data_list[current_level_idx].difficulty,
			lives_left,
			hints_left
		)

	candidate.play_hint_pulse()
	hud.show_message("Follow the blue light to the arrow", true)
	SettingsManager.play_haptic(&"light")

func _open_hint_refill_popup() -> void:
	if hint_refill_popup != null or input_locked:
		return

	input_locked = true
	board.set_input_enabled(false)
	hud.set_controls_enabled(false)
	hint_refill_popup = HintRefillPopupScene.instantiate() as HintRefillPopup
	if hint_refill_popup == null:
		push_error("Hint refill scene does not use HintRefillPopup script.")
		input_locked = false
		board.set_input_enabled(true)
		hud.set_controls_enabled(true)
		return

	add_child(hint_refill_popup)
	hint_refill_popup.refill_pressed.connect(_on_hint_refill_confirmed)
	hint_refill_popup.cancelled.connect(_on_hint_refill_cancelled)

func _on_hint_refill_confirmed() -> void:
	var hints_used_before_refill := maxi(hints_at_level_start - hints_left, 0)
	hints_left = HINT_REFILL_AMOUNT
	hints_at_level_start = hints_used_before_refill + hints_left
	SaveManager.hint_count = hints_left
	SaveManager.save_game()
	hud.update_hud(
		level_data_list[current_level_idx].level_id,
		level_data_list[current_level_idx].difficulty,
		lives_left,
		hints_left
	)
	_close_hint_refill_popup(true)
	hud.show_message("3 hints added", true)
	SettingsManager.play_haptic(&"success")

func _on_hint_refill_cancelled() -> void:
	_close_hint_refill_popup(true)

func _close_hint_refill_popup(resume_gameplay: bool) -> void:
	if hint_refill_popup != null:
		hint_refill_popup.queue_free()
	hint_refill_popup = null
	if resume_gameplay:
		input_locked = false
		board.set_input_enabled(true)
		hud.set_controls_enabled(true)

func _on_settings_pressed() -> void:
	_open_pause_menu()

func _open_pause_menu() -> void:
	if pause_menu != null or hint_refill_popup != null or input_locked:
		return
	input_locked = true
	board.set_input_enabled(false)
	hud.set_controls_enabled(false)
	pause_menu = PauseMenuScene.instantiate() as PauseMenu
	if pause_menu == null:
		push_error("Pause menu scene does not use PauseMenu script.")
		input_locked = false
		board.set_input_enabled(true)
		hud.set_controls_enabled(true)
		return
	add_child(pause_menu)
	pause_menu.resume_pressed.connect(_resume_from_pause)
	pause_menu.restart_pressed.connect(_restart_from_pause)
	pause_menu.menu_pressed.connect(_menu_from_pause)
	get_tree().paused = true

func _resume_from_pause() -> void:
	_close_pause_menu(true)

func _restart_from_pause() -> void:
	_close_pause_menu(false)
	load_level(current_level_idx)

func _menu_from_pause() -> void:
	get_tree().paused = false
	SaveManager.current_level = current_level_idx
	SaveManager.hint_count = hints_left
	SaveManager.save_game()
	if pause_menu != null:
		pause_menu.queue_free()
		pause_menu = null
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _close_pause_menu(resume_gameplay: bool) -> void:
	if get_tree().paused:
		get_tree().paused = false
	if pause_menu != null:
		pause_menu.queue_free()
		pause_menu = null
	if resume_gameplay:
		input_locked = false
		board.set_input_enabled(true)
		hud.set_controls_enabled(true)

func _lock_gameplay() -> void:
	input_locked = true
	board.set_input_enabled(false)
	hud.set_controls_enabled(false)
	board.update_assist_pulses(false)

func _on_back_pressed() -> void:
	SaveManager.current_level = current_level_idx
	SaveManager.hint_count = hints_left
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return
	if hint_refill_popup != null:
		_on_hint_refill_cancelled()
	elif pause_menu != null:
		_resume_from_pause()
	elif not input_locked:
		_open_pause_menu()
	get_viewport().set_input_as_handled()

func _update_layout() -> void:
	if board == null or board_pivot == null:
		return
	var viewport_size := get_viewport_rect().size
	var top_space := minf(TOP_RESERVED, viewport_size.y * 0.22)
	var bottom_space := minf(BOTTOM_RESERVED, viewport_size.y * 0.22)
	var available_size := Vector2(
		maxf(viewport_size.x - SIDE_MARGIN * 2.0, 240.0),
		maxf(viewport_size.y - top_space - bottom_space, 240.0)
	)
	board_pivot.position = Vector2(viewport_size.x * 0.5, top_space + available_size.y * 0.5)

	var visual_size: Vector2 = board.get_visual_size()
	if visual_size.x <= 0.0 or visual_size.y <= 0.0:
		return
	var scale_factor := minf(available_size.x / visual_size.x, available_size.y / visual_size.y)
	scale_factor = clampf(scale_factor, 0.35, MAX_BOARD_SCALE)
	board_pivot.scale = Vector2.ONE * scale_factor
