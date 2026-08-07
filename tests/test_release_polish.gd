extends SceneTree

var PuzzlePieceScene: PackedScene = preload("res://scenes/game/puzzle_piece.tscn")

func _init() -> void:
	print("--- Running Pathbreak Release Polish Test Suite ---")
	var tests: Array[Callable] = [
		test_full_motion_timing_budget,
		test_bent_path_accelerates_only_after_uncoil,
		test_reduce_motion_keeps_short_escape
	]
	var passed := 0
	for test_index in range(tests.size()):
		var result: bool = tests[test_index].call()
		print("%s Release polish test %d" % ["PASS" if result else "FAIL", test_index + 1])
		if result:
			passed += 1
	print("Release polish: %d/%d passed" % [passed, tests.size()])
	quit(0 if passed == tests.size() else 1)

func _make_bent_piece() -> PuzzlePiece:
	var piece := PuzzlePieceScene.instantiate() as PuzzlePiece
	root.add_child(piece)
	var data := PuzzlePieceData.create(
		1,
		[[0, 0], [1, 0], [1, 1]],
		Vector2i.DOWN
	)
	piece.init_from_data(data, 64.0)
	return piece

func _set_reduce_motion(value: bool) -> bool:
	var sm: Node = root.get_node_or_null("SettingsManager")
	if sm == null:
		var main_tree := Engine.get_main_loop() as SceneTree
		if main_tree and main_tree.root:
			sm = main_tree.root.get_node_or_null("SettingsManager")
	if sm == null:
		sm = Node.new()
		sm.name = "SettingsManager"
		root.add_child(sm)

	var previous: bool = false
	if "reduce_motion" in sm:
		previous = sm.reduce_motion == true
	elif sm.has_meta("reduce_motion"):
		previous = sm.get_meta("reduce_motion") == true

	if sm.has_method("set_reduce_motion"):
		sm.call("set_reduce_motion", value)
	if "reduce_motion" in sm:
		sm.reduce_motion = value
	sm.set_meta("reduce_motion", value)
	return previous

func test_full_motion_timing_budget() -> bool:
	var previous_reduce_motion := _set_reduce_motion(false)
	var piece := _make_bent_piece()
	var duration := piece.get_escape_animation_duration()
	var passed := duration >= 0.27 and duration <= 0.30
	if not passed:
		push_error("Full-motion release duration left the 270–300 ms budget: %.3f" % duration)
	piece.queue_free()
	_set_reduce_motion(previous_reduce_motion)
	return passed

func test_bent_path_accelerates_only_after_uncoil() -> bool:
	var previous_reduce_motion := _set_reduce_motion(false)
	var piece := _make_bent_piece()
	if not piece._prepare_snake_escape():
		push_error("Bent-path release preparation failed.")
		piece.queue_free()
		_set_reduce_motion(previous_reduce_motion)
		return false

	var uncoil_end := piece._snake_travel_for_progress(0.72)
	if not is_equal_approx(uncoil_end, piece.snake_body_length):
		push_error(
			"Bent path must finish its authored uncoil before off-board acceleration: %.3f vs %.3f" % [
				uncoil_end,
				piece.snake_body_length
			]
		)
		piece.queue_free()
		_set_reduce_motion(previous_reduce_motion)
		return false

	var halfway_exit_progress := 0.86
	var halfway_exit_travel := piece._snake_travel_for_progress(halfway_exit_progress) - piece.snake_body_length
	var linear_half_exit := piece.snake_exit_distance * 0.5
	var passed := halfway_exit_travel > 0.0 and halfway_exit_travel < linear_half_exit
	if not passed:
		push_error(
			"Expected restrained first-half exit travel before late acceleration: %.3f vs linear %.3f" % [
				halfway_exit_travel,
				linear_half_exit
			]
		)

	piece.queue_free()
	_set_reduce_motion(previous_reduce_motion)
	return passed

func test_reduce_motion_keeps_short_escape() -> bool:
	var previous_reduce_motion := _set_reduce_motion(true)
	var piece := _make_bent_piece()
	var duration := piece.get_escape_animation_duration()
	var passed := is_equal_approx(duration, 0.18)
	if not passed:
		push_error("Reduce Motion release duration should remain 0.18 seconds, got %.3f" % duration)
	piece.queue_free()
	_set_reduce_motion(previous_reduce_motion)
	return passed
