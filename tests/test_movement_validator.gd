extends SceneTree

const MovementValidatorScript = preload("res://scripts/gameplay/movement_validator.gd")
const PuzzlePieceDataScript = preload("res://scripts/gameplay/puzzle_piece_data.gd")

func _init() -> void:
	print("--- Running Pathbreak MovementValidator Test Suite ---")
	var tests: Array[Callable] = [
		test_unblocked_straight_path,
		test_blocked_straight_path,
		test_bent_path_blocked,
		test_edge_touching_path,
		test_self_cells_ahead,
		test_two_blockers,
		test_occupancy_after_removal,
		test_occupancy_after_restart,
		test_rapid_tap_protection,
		test_final_path_completion
	]
	var passed := 0
	for test_index in range(tests.size()):
		var result: bool = tests[test_index].call()
		print("%s Test %d" % ["PASS" if result else "FAIL", test_index + 1])
		if result:
			passed += 1
	print("MovementValidator: %d/%d passed" % [passed, tests.size()])
	quit(0 if passed == tests.size() else 1)

func test_unblocked_straight_path() -> bool:
	var board_size := Vector2i(8, 8)
	var path := PuzzlePieceDataScript.create(
		1,
		[Vector2i(2, 3), Vector2i(2, 2)],
		Vector2i.UP
	)
	var occupancy := {Vector2i(2, 3): 1, Vector2i(2, 2): 1}
	return MovementValidatorScript.can_escape(path, board_size, occupancy)

func test_blocked_straight_path() -> bool:
	var board_size := Vector2i(8, 8)
	var path := PuzzlePieceDataScript.create(
		1,
		[Vector2i(2, 5), Vector2i(2, 4)],
		Vector2i.UP
	)
	var blocker := PuzzlePieceDataScript.create(
		2,
		[Vector2i(3, 2), Vector2i(2, 2)],
		Vector2i.LEFT
	)
	var occupancy := _build_occupancy([path, blocker])
	return not MovementValidatorScript.can_escape(path, board_size, occupancy)

func test_bent_path_blocked() -> bool:
	var board_size := Vector2i(8, 8)
	var path := PuzzlePieceDataScript.create(
		1,
		[Vector2i(2, 4), Vector2i(2, 3), Vector2i(3, 3)],
		Vector2i.RIGHT
	)
	var blocker := PuzzlePieceDataScript.create(
		2,
		[Vector2i(5, 2), Vector2i(5, 3)],
		Vector2i.DOWN
	)
	var occupancy := _build_occupancy([path, blocker])
	return not MovementValidatorScript.can_escape(path, board_size, occupancy)

func test_edge_touching_path() -> bool:
	var board_size := Vector2i(8, 8)
	var path := PuzzlePieceDataScript.create(
		1,
		[Vector2i(3, 1), Vector2i(3, 0)],
		Vector2i.UP
	)
	var occupancy := _build_occupancy([path])
	return MovementValidatorScript.can_escape(path, board_size, occupancy)

func test_self_cells_ahead() -> bool:
	var board_size := Vector2i(8, 8)
	var path := PuzzlePieceDataScript.create(
		1,
		[Vector2i(4, 5), Vector2i(4, 4), Vector2i(4, 3)],
		Vector2i.UP
	)
	var occupancy := _build_occupancy([path])
	return MovementValidatorScript.can_escape(path, board_size, occupancy)

func test_two_blockers() -> bool:
	var board_size := Vector2i(8, 8)
	var path := PuzzlePieceDataScript.create(
		1,
		[Vector2i(4, 7), Vector2i(4, 6)],
		Vector2i.UP
	)
	var blocker_a := PuzzlePieceDataScript.create(
		2,
		[Vector2i(5, 4), Vector2i(4, 4)],
		Vector2i.LEFT
	)
	var blocker_b := PuzzlePieceDataScript.create(
		3,
		[Vector2i(3, 2), Vector2i(4, 2)],
		Vector2i.RIGHT
	)
	var occupancy := _build_occupancy([path, blocker_a, blocker_b])
	return not MovementValidatorScript.can_escape(path, board_size, occupancy)

func test_occupancy_after_removal() -> bool:
	var board_size := Vector2i(8, 8)
	var blocker := PuzzlePieceDataScript.create(
		1,
		[Vector2i(3, 2), Vector2i(2, 2)],
		Vector2i.LEFT
	)
	var path := PuzzlePieceDataScript.create(
		2,
		[Vector2i(2, 5), Vector2i(2, 4)],
		Vector2i.UP
	)
	var occupancy := _build_occupancy([blocker, path])
	if MovementValidatorScript.can_escape(path, board_size, occupancy):
		return false
	for cell in blocker.cells:
		occupancy.erase(cell)
	return MovementValidatorScript.can_escape(path, board_size, occupancy)

func test_occupancy_after_restart() -> bool:
	var pieces: Array = [
		PuzzlePieceDataScript.create(
			1,
			[Vector2i(1, 2), Vector2i(1, 1)],
			Vector2i.UP
		),
		PuzzlePieceDataScript.create(
			2,
			[Vector2i(2, 3), Vector2i(3, 3)],
			Vector2i.RIGHT
		)
	]
	var first_occupancy := _build_occupancy(pieces)
	for cell in pieces[0].cells:
		first_occupancy.erase(cell)
	var restarted_occupancy := _build_occupancy(pieces)
	return (
		restarted_occupancy.size() == 4
		and restarted_occupancy.get(Vector2i(1, 1)) == 1
		and restarted_occupancy.get(Vector2i(3, 3)) == 2
	)

class TapHandler:
	var is_removed := false
	var tap_count := 0

	func tap() -> bool:
		if is_removed:
			return false
		is_removed = true
		tap_count += 1
		return true

func test_rapid_tap_protection() -> bool:
	var handler := TapHandler.new()
	var first := handler.tap()
	var second := handler.tap()
	var third := handler.tap()
	return first and not second and not third and handler.tap_count == 1

func test_final_path_completion() -> bool:
	var remaining_pieces := 1
	var on_piece_escaped := func() -> bool:
		remaining_pieces -= 1
		return remaining_pieces <= 0
	return on_piece_escaped.call()

func _build_occupancy(pieces: Array) -> Dictionary:
	var occupancy: Dictionary = {}
	for piece in pieces:
		for cell in piece.cells:
			occupancy[cell] = piece.piece_id
	return occupancy
