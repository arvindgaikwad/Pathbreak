extends SceneTree

func _init() -> void:
	print("--- Running Pathbreak Production Level Studio Analysis Tests ---")
	var tests: Array[Callable] = [
		test_forced_dependency_metrics,
		test_shared_validator_rejects_overlap
	]
	var passed := 0
	for test_index in range(tests.size()):
		var result: bool = tests[test_index].call()
		print("%s Level studio test %d" % ["PASS" if result else "FAIL", test_index + 1])
		if result:
			passed += 1
	print("Level studio analysis: %d/%d passed" % [passed, tests.size()])
	quit(0 if passed == tests.size() else 1)

func test_forced_dependency_metrics() -> bool:
	var level := PuzzleLevelData.new()
	level.level_id = 9101
	level.board_size = Vector2i(4, 4)
	level.pieces.append(PuzzlePieceData.create(
		1,
		[[0, 1], [1, 1]],
		Vector2i.RIGHT
	))
	level.pieces.append(PuzzlePieceData.create(
		2,
		[[2, 1], [2, 2]],
		Vector2i.DOWN
	))

	var errors := LevelDataValidator.validate(level)
	if not errors.is_empty():
		push_error("Expected forced-chain fixture to validate: %s" % errors)
		return false

	var report := LevelSolver.analyze(level, 100)
	var passed := (
		bool(report["solvable"])
		and int(report["piece_count"]) == 2
		and int(report["opening_move_count"]) == 1
		and int(report["solution_count"]) == 1
		and int(report["forced_state_count"]) == 2
		and int(report["branch_state_count"]) == 0
		and int(report["longest_forced_chain"]) == 2
	)
	if not passed:
		push_error("Unexpected forced-chain analysis: %s" % report)
	return passed

func test_shared_validator_rejects_overlap() -> bool:
	var level := PuzzleLevelData.new()
	level.level_id = 9102
	level.board_size = Vector2i(4, 4)
	level.pieces.append(PuzzlePieceData.create(
		1,
		[[0, 0], [1, 0]],
		Vector2i.RIGHT
	))
	level.pieces.append(PuzzlePieceData.create(
		2,
		[[1, 0], [1, 1]],
		Vector2i.DOWN
	))

	var errors := LevelDataValidator.validate(level)
	if errors.is_empty():
		push_error("Expected shared validator to reject overlapping authored paths.")
		return false
	for error in errors:
		if "shared by pieces" in error:
			return true
	push_error("Overlap was invalid but expected overlap-specific error was missing: %s" % errors)
	return false
