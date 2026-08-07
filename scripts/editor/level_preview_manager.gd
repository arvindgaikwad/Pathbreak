extends "res://scripts/gameplay/level_manager.gd"

const LevelStudioPreviewSessionScript = preload("res://scripts/editor/level_studio_preview_session.gd")
const EDITOR_SCENE := "res://scenes/LevelEditor.tscn"

var _saved_tutorial_completed: bool = true

func _ready() -> void:
	_saved_tutorial_completed = SaveManager.tutorial_completed
	# Preview must never enable tutorial assist pulses or tutorial-only copy. This is
	# intentionally kept in memory only and restored before leaving the preview.
	SaveManager.tutorial_completed = true
	super._ready()
	if not level_data_list.is_empty():
		hud.show_message("Studio Preview • Back returns to editor", true)

func _load_levels() -> void:
	level_data_list.clear()
	var preview_level: PuzzleLevelData = LevelStudioPreviewSessionScript.get_preview_level()
	if preview_level == null:
		push_error("Level Studio preview session is missing a level.")
		return
	var errors := LevelDataValidator.validate(preview_level)
	if not errors.is_empty():
		push_error("Level Studio preview level is invalid: %s" % errors)
		return
	level_data_list.append(preview_level)

func load_level(_index: int) -> void:
	if level_data_list.is_empty():
		return

	_close_pause_menu(false)
	_close_hint_refill_popup(false)
	input_locked = false
	board.set_input_enabled(true)
	hud.set_controls_enabled(true)
	current_level_idx = 0
	hints_left = 5

	var level_data := level_data_list[0]
	move_count = 0
	mistake_count = 0
	lives_left = maxi(level_data.starting_lives, 1)
	hints_at_level_start = hints_left
	level_start_msec = Time.get_ticks_msec()

	board.setup_level(level_data)
	total_pieces = level_data.pieces.size()
	remaining_pieces = total_pieces
	hud.update_hud(level_data.level_id, level_data.difficulty, lives_left, hints_left)
	board.update_assist_pulses(false)
	_update_layout()

func _on_hint_pressed() -> void:
	if input_locked:
		return
	var candidate: PuzzlePiece = board.get_first_escapable_piece()
	if candidate == null:
		hud.show_message("No path can leave yet")
		return
	candidate.play_hint_pulse()
	hud.show_message("Preview hint", true)
	SettingsManager.play_haptic(&"light")

func _on_restart_pressed() -> void:
	load_level(0)
	hud.show_message("Studio Preview • Back returns to editor", true)

func _on_level_completed() -> void:
	board.play_completion_settle()
	AudioManager.play_win_sound()
	SettingsManager.play_haptic(&"celebration")
	var settle_delay: float = (
		REDUCE_MOTION_RESULT_GAP
		if SettingsManager.reduce_motion
		else board.get_completion_settle_duration()
	)
	get_tree().create_timer(settle_delay).timeout.connect(func() -> void:
		if not is_inside_tree():
			return
		hud.show_message("Preview complete • Back to edit", true)
		# Keep the board locked after completion, but re-enable HUD so Back and
		# Restart remain available to the level author.
		hud.set_controls_enabled(true)
	)

func _show_fail_screen() -> void:
	var fail_screen = FailScreenScene.instantiate()
	add_child(fail_screen)
	fail_screen.retry_pressed.connect(func() -> void:
		fail_screen.queue_free()
		load_level(0)
	)
	fail_screen.menu_pressed.connect(func() -> void:
		fail_screen.queue_free()
		_return_to_editor()
	)

func _menu_from_pause() -> void:
	get_tree().paused = false
	if pause_menu != null:
		pause_menu.queue_free()
		pause_menu = null
	_return_to_editor()

func _on_back_pressed() -> void:
	_return_to_editor()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and input_locked and pause_menu == null and hint_refill_popup == null:
		_return_to_editor()
		get_viewport().set_input_as_handled()
		return
	super._unhandled_input(event)

func _return_to_editor() -> void:
	if get_tree().paused:
		get_tree().paused = false
	SaveManager.tutorial_completed = _saved_tutorial_completed
	get_tree().change_scene_to_file(EDITOR_SCENE)
