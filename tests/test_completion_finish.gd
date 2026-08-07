extends SceneTree

var PuzzlePieceScene: PackedScene = preload("res://scenes/game/puzzle_piece.tscn")
var BoardScene: PackedScene = preload("res://scenes/game/board.tscn")

func _init() -> void:
	print("--- Running Pathbreak Completion Finish Test Suite ---")
	var tests: Array[Callable] = [
		test_full_motion_finish_budget,
		test_reduce_motion_finish_budget,
		test_final_preview_is_not_hint_marker
	]
	var passed := 0
	for test_index in range(tests.size()):
		var result: bool = tests[test_index].call()
		print("%s Completion finish test %d" % ["PASS" if result else "FAIL", test_index + 1])
		if result:
			passed += 1
	print("Completion finish: %d/%d passed" % [passed, tests.size()])
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

func _make_board():
	var board = BoardScene.instantiate()
	root.add_child(board)
	return board

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

func test_full_motion_finish_budget() -> bool:
	var previous_reduce_motion := _set_reduce_motion(false)
	var piece := _make_bent_piece()
	var board = _make_board()
	var coordinator_gap := 0.015
	var total: float = (
		piece.get_final_clear_preview_duration()
		+ piece.get_escape_animation_duration()
		+ coordinator_gap
		+ board.get_completion_settle_duration()
	)
	var passed: bool = total >= 0.40 and total <= 0.70
	if not passed:
		push_error("Full completion finish left the 400–700 ms budget: %.3f" % total)
	piece.queue_free()
	board.queue_free()
	_set_reduce_motion(previous_reduce_motion)
	return passed

func test_reduce_motion_finish_budget() -> bool:
	var previous_reduce_motion := _set_reduce_motion(true)
	var piece := _make_bent_piece()
	var board = _make_board()
	var coordinator_gap := 0.015
	var reduced_result_gap := 0.040
	var total: float = (
		piece.get_final_clear_preview_duration()
		+ piece.get_escape_animation_duration()
		+ coordinator_gap
		+ reduced_result_gap
		+ board.get_completion_settle_duration()
	)
	var passed: bool = total <= 0.30
	if not passed:
		push_error("Reduce Motion completion finish should stay under 300 ms: %.3f" % total)
	piece.queue_free()
	board.queue_free()
	_set_reduce_motion(previous_reduce_motion)
	return passed

func test_final_preview_is_not_hint_marker() -> bool:
	var previous_reduce_motion := _set_reduce_motion(false)
	var piece := _make_bent_piece()
	piece.play_final_clear_preview()
	var passed := piece.direction_marker != null and not piece.direction_marker.visible
	if not passed:
		push_error("Final automatic clear preview must not reuse the travelling hint marker.")
	piece.queue_free()
	_set_reduce_motion(previous_reduce_motion)
	return passed
