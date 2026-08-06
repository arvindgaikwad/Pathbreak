extends SceneTree

const LevelDataValidatorScript = preload("res://scripts/gameplay/level_data_validator.gd")
const PuzzleLevelDataScript = preload("res://scripts/gameplay/puzzle_level_data.gd")
const PuzzlePieceDataScript = preload("res://scripts/gameplay/puzzle_piece_data.gd")

func _init() -> void:
	print("--- Running Pathbreak LevelDataValidator Test Suite ---")
	var tests: Array[Callable] = [
		test_valid_level,
		test_invalid_board_size,
		test_duplicate_cell,
		test_non_adjacent_cells,
		test_invalid_direction,
		test_duplicate_piece_id,
		test_out_of_bounds_cell,
		test_occupancy_build
	]
	var passed := 0
	for test_index in range(tests.size()):
		var result: bool = tests[test_index].call()
		print("%s Test %d" % ["PASS" if result else "FAIL", test_index + 1])
		if result:
			passed += 1
	print("Level data validation: %d/%d passed" % [passed, tests.size()])
	quit(0 if passed == tests.size() else 1)

func _make_level() -> PuzzleLevelData:
	var level := PuzzleLevelDataScript.new() as PuzzleLevelData
	level.level_id = 1
	level.board_size = Vector2i(6, 6)
	level.starting_lives = 3
	level.pieces.append(PuzzlePieceDataScript.create(1, [[1, 1], [2, 1]], Vector2i.RIGHT))
	level.pieces.append(PuzzlePieceDataScript.create(2, [[4, 3], [4, 4]], Vector2i.DOWN))
	return level

func test_valid_level() -> bool:
	return LevelDataValidatorScript.is_valid(_make_level())

func test_invalid_board_size() -> bool:
	var level := _make_level()
	level.board_size = Vector2i.ZERO
	return not LevelDataValidatorScript.is_valid(level)

func test_duplicate_cell() -> bool:
	var level := _make_level()
	level.pieces.append(PuzzlePieceDataScript.create(3, [[2, 1], [2, 2]], Vector2i.DOWN))
	return not LevelDataValidatorScript.is_valid(level)

func test_non_adjacent_cells() -> bool:
	var level := _make_level()
	level.pieces[0].cells.clear()
	level.pieces[0].cells.append(Vector2i(1, 1))
	level.pieces[0].cells.append(Vector2i(3, 1))
	return not LevelDataValidatorScript.is_valid(level)

func test_invalid_direction() -> bool:
	var level := _make_level()
	level.pieces[0].exit_direction = Vector2i(1, 1)
	return not LevelDataValidatorScript.is_valid(level)

func test_duplicate_piece_id() -> bool:
	var level := _make_level()
	level.pieces[1].piece_id = 1
	return not LevelDataValidatorScript.is_valid(level)

func test_out_of_bounds_cell() -> bool:
	var level := _make_level()
	level.pieces[0].cells.clear()
	level.pieces[0].cells.append(Vector2i(5, 5))
	level.pieces[0].cells.append(Vector2i(6, 5))
	return not LevelDataValidatorScript.is_valid(level)

func test_occupancy_build() -> bool:
	var level := _make_level()
	var occupancy: Dictionary = LevelDataValidatorScript.build_occupancy(level)
	return occupancy.size() == 4 and occupancy[Vector2i(2, 1)] == 1 and occupancy[Vector2i(4, 4)] == 2
