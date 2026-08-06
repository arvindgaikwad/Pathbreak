extends SceneTree

const LevelDataValidatorScript = preload("res://scripts/gameplay/level_data_validator.gd")
const LevelSolverScript = preload("res://scripts/gameplay/level_solver.gd")
const PuzzleLevelDataScript = preload("res://scripts/gameplay/puzzle_level_data.gd")
const PuzzlePieceDataScript = preload("res://scripts/gameplay/puzzle_piece_data.gd")

var levels: Array[PuzzleLevelData] = []

func _init() -> void:
	print("--- Running Pathbreak Vertical Slice Level Test Suite ---")
	levels = _load_slice_levels()
	var tests: Array[Callable] = [
		test_all_levels_load_and_validate,
		test_all_levels_are_solvable_without_dead_ends,
		test_level_1_teaches_two_safe_openings,
		test_level_5_uses_an_authored_dependency_chain,
		test_opening_move_curve,
		test_solution_sequence_counts
	]
	var passed := 0
	for test_index in range(tests.size()):
		var result: bool = tests[test_index].call()
		print("%s Test %d" % ["PASS" if result else "FAIL", test_index + 1])
		if result:
			passed += 1
	print("Vertical slice levels: %d/%d passed" % [passed, tests.size()])
	quit(0 if passed == tests.size() else 1)

func test_all_levels_load_and_validate() -> bool:
	if levels.size() != 5:
		push_error("Expected five vertical-slice levels, loaded %d." % levels.size())
		return false
	for level in levels:
		var errors := LevelDataValidatorScript.validate(level)
		if not errors.is_empty():
			push_error("Level %d validation failed: %s" % [level.level_id, "; ".join(errors)])
			return false
	return true

func test_all_levels_are_solvable_without_dead_ends() -> bool:
	if levels.size() != 5:
		return false
	for level in levels:
		var solution_count := LevelSolverScript.count_solutions(level, 100000)
		var solution := LevelSolverScript.find_one_solution(level)
		if solution_count <= 0:
			push_error("Level %d has no full-clear solution." % level.level_id)
			return false
		if solution.size() != level.pieces.size():
			push_error("Level %d returned an incomplete solution." % level.level_id)
			return false
		if LevelSolverScript.has_reachable_dead_end(level):
			push_error("Level %d has a reachable dead-end state after legal moves." % level.level_id)
			return false
	return true

func test_level_1_teaches_two_safe_openings() -> bool:
	var level := _get_level(1)
	if level == null:
		return false
	var openings := LevelSolverScript.get_initial_escapable_piece_ids(level)
	var solution_count := LevelSolverScript.count_solutions(level)
	return level.pieces.size() == 2 and openings.size() == 2 and solution_count == 2

func test_level_5_uses_an_authored_dependency_chain() -> bool:
	var level := _get_level(5)
	if level == null:
		return false
	var openings := LevelSolverScript.get_initial_escapable_piece_ids(level)
	var solution_count := LevelSolverScript.count_solutions(level, 100)
	var bent_piece_count := _count_bent_pieces(level)
	return (
		level.pieces.size() == 8
		and openings.size() == 1
		and solution_count == 6
		and bent_piece_count >= 2
	)

func test_opening_move_curve() -> bool:
	var expected_openings: Array[int] = [2, 1, 3, 2, 1]
	if levels.size() != expected_openings.size():
		return false
	for level_index in range(levels.size()):
		var actual := LevelSolverScript.get_initial_escapable_piece_ids(levels[level_index]).size()
		if actual != expected_openings[level_index]:
			push_error(
				"Level %d expected %d opening moves, found %d." % [
					level_index + 1,
					expected_openings[level_index],
					actual
				]
			)
			return false
	return true

func test_solution_sequence_counts() -> bool:
	var expected_counts: Array[int] = [2, 1, 12, 7, 6]
	if levels.size() != expected_counts.size():
		return false
	for level_index in range(levels.size()):
		var actual := LevelSolverScript.count_solutions(levels[level_index], 100000)
		print(
			"Level %d audit: pieces=%d openings=%d solutions=%d bends=%d" % [
				level_index + 1,
				levels[level_index].pieces.size(),
				LevelSolverScript.get_initial_escapable_piece_ids(levels[level_index]).size(),
				actual,
				_count_bent_pieces(levels[level_index])
			]
		)
		if actual != expected_counts[level_index]:
			push_error(
				"Level %d expected %d solution sequences, found %d." % [
					level_index + 1,
					expected_counts[level_index],
					actual
				]
			)
			return false
	return true

func _load_slice_levels() -> Array[PuzzleLevelData]:
	var loaded_levels: Array[PuzzleLevelData] = []
	for level_number in range(1, 6):
		var level := _load_json_level(level_number)
		if level == null:
			push_error("Unable to load data/level%d.json." % level_number)
			break
		loaded_levels.append(level)
	return loaded_levels

func _load_json_level(level_number: int) -> PuzzleLevelData:
	var path := "res://data/level%d.json" % level_number
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null

	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return null

	var data: Dictionary = parsed
	var level := PuzzleLevelDataScript.new() as PuzzleLevelData
	level.level_id = level_number
	level.board_size = Vector2i(int(data.get("width", 8)), int(data.get("height", 8)))
	level.starting_lives = int(data.get("lives", 3))
	level.difficulty = "Easy" if level_number <= 3 else "Normal"

	var piece_id := 1
	for raw_piece in data.get("pieces", []):
		if not raw_piece is Dictionary:
			continue
		var piece_data: Dictionary = raw_piece
		var direction_data: Array = piece_data.get("direction", [1, 0])
		if direction_data.size() < 2:
			continue
		var piece := PuzzlePieceDataScript.create(
			piece_id,
			piece_data.get("cells", []),
			Vector2i(int(direction_data[0]), int(direction_data[1]))
		)
		level.pieces.append(piece)
		piece_id += 1

	return level

func _get_level(level_id: int) -> PuzzleLevelData:
	for level in levels:
		if level.level_id == level_id:
			return level
	return null

func _count_bent_pieces(level: PuzzleLevelData) -> int:
	var bent_count := 0
	for piece in level.pieces:
		if piece == null or piece.cells.size() < 3:
			continue
		var first_step := piece.cells[1] - piece.cells[0]
		for cell_index in range(2, piece.cells.size()):
			var current_step := piece.cells[cell_index] - piece.cells[cell_index - 1]
			if current_step != first_step:
				bent_count += 1
				break
	return bent_count
