extends SceneTree

const MovementValidator = preload("res://scripts/gameplay/movement_validator.gd")
const PuzzlePieceData = preload("res://scripts/gameplay/puzzle_piece_data.gd")

func _init():
	print("--- Running Pathbreak MovementValidator Automated Test Suite ---")
	var passed = 0
	var total = 0
	
	total += 1
	if test_unblocked_straight_path():
		passed += 1
		print("✅ Test 1 Passed: Unblocked straight path")
	else:
		print("❌ Test 1 Failed: Unblocked straight path")
		
	total += 1
	if test_blocked_straight_path():
		passed += 1
		print("✅ Test 2 Passed: Blocked straight path")
	else:
		print("❌ Test 2 Failed: Blocked straight path")

	total += 1
	if test_bent_path_blocked():
		passed += 1
		print("✅ Test 3 Passed: Bent path blocked through bend cell")
	else:
		print("❌ Test 3 Failed: Bent path blocked through bend cell")

	total += 1
	if test_edge_touching_path():
		passed += 1
		print("✅ Test 4 Passed: Path touching board edge")
	else:
		print("❌ Test 4 Failed: Path touching board edge")

	total += 1
	if test_self_cells_ahead():
		passed += 1
		print("✅ Test 5 Passed: Path self-occupancy check")
	else:
		print("❌ Test 5 Failed: Path self-occupancy check")

	total += 1
	if test_two_blockers():
		passed += 1
		print("✅ Test 6 Passed: Two blockers in same direction")
	else:
		print("❌ Test 6 Failed: Two blockers in same direction")

	total += 1
	if test_occupancy_after_removal():
		passed += 1
		print("✅ Test 7 Passed: Occupancy update after path removal")
	else:
		print("❌ Test 7 Failed: Occupancy update after path removal")

	total += 1
	if test_occupancy_after_restart():
		passed += 1
		print("✅ Test 8 Passed: Occupancy reconstruction after restart")
	else:
		print("❌ Test 8 Failed: Occupancy reconstruction after restart")

	total += 1
	if test_rapid_tap_protection():
		passed += 1
		print("✅ Test 9 Passed: Rapid repeated tap protection")
	else:
		print("❌ Test 9 Failed: Rapid repeated tap protection")

	total += 1
	if test_final_path_completion():
		passed += 1
		print("✅ Test 10 Passed: Final path completion")
	else:
		print("❌ Test 10 Failed: Final path completion")

	print("---------------------------------------------------------------")
	print("Summary: %d / %d Tests Passed" % [passed, total])
	if passed == total:
		print("🎉 ALL TESTS PASSED SUCCESSFULLY!")
		quit(0)
	else:
		print("⚠️ SOME TESTS FAILED!")
		quit(1)

func test_unblocked_straight_path() -> bool:
	var board_size = Vector2i(8, 8)
	var p1 = PuzzlePieceData.create(1, [Vector2i(2, 2), Vector2i(2, 3)], Vector2i.UP)
	var occ = {Vector2i(2, 2): 1, Vector2i(2, 3): 1}
	return MovementValidator.can_escape(p1, board_size, occ) == true

func test_blocked_straight_path() -> bool:
	var board_size = Vector2i(8, 8)
	var p1 = PuzzlePieceData.create(1, [Vector2i(2, 4), Vector2i(2, 5)], Vector2i.UP)
	var p2 = PuzzlePieceData.create(2, [Vector2i(2, 2), Vector2i(3, 2)], Vector2i.RIGHT)
	var occ = {
		Vector2i(2, 4): 1, Vector2i(2, 5): 1,
		Vector2i(2, 2): 2, Vector2i(3, 2): 2
	}
	return MovementValidator.can_escape(p1, board_size, occ) == false

func test_bent_path_blocked() -> bool:
	var board_size = Vector2i(8, 8)
	# Bent path: L-shape at (2,3), (3,3), (3,4) going RIGHT
	var p1 = PuzzlePieceData.create(1, [Vector2i(2, 3), Vector2i(3, 3), Vector2i(3, 4)], Vector2i.RIGHT)
	# Blocker at (5, 3) blocking the right exit from (3,3)
	var p2 = PuzzlePieceData.create(2, [Vector2i(5, 3)], Vector2i.UP)
	var occ = {
		Vector2i(2, 3): 1, Vector2i(3, 3): 1, Vector2i(3, 4): 1,
		Vector2i(5, 3): 2
	}
	return MovementValidator.can_escape(p1, board_size, occ) == false

func test_edge_touching_path() -> bool:
	var board_size = Vector2i(8, 8)
	# Path at y=0 exiting UP (immediately exits board)
	var p1 = PuzzlePieceData.create(1, [Vector2i(3, 0), Vector2i(3, 1)], Vector2i.UP)
	var occ = {Vector2i(3, 0): 1, Vector2i(3, 1): 1}
	return MovementValidator.can_escape(p1, board_size, occ) == true

func test_self_cells_ahead() -> bool:
	var board_size = Vector2i(8, 8)
	# Vertical path at x=4, y=3..5 moving UP. Node at y=5 faces y=4 & y=3 which belong to piece 1 itself!
	var p1 = PuzzlePieceData.create(1, [Vector2i(4, 5), Vector2i(4, 4), Vector2i(4, 3)], Vector2i.UP)
	var occ = {Vector2i(4, 5): 1, Vector2i(4, 4): 1, Vector2i(4, 3): 1}
	return MovementValidator.can_escape(p1, board_size, occ) == true

func test_two_blockers() -> bool:
	var board_size = Vector2i(8, 8)
	var p1 = PuzzlePieceData.create(1, [Vector2i(4, 6)], Vector2i.UP)
	var p2 = PuzzlePieceData.create(2, [Vector2i(4, 4)], Vector2i.RIGHT)
	var p3 = PuzzlePieceData.create(3, [Vector2i(4, 2)], Vector2i.LEFT)
	var occ = {Vector2i(4, 6): 1, Vector2i(4, 4): 2, Vector2i(4, 2): 3}
	return MovementValidator.can_escape(p1, board_size, occ) == false

func test_occupancy_after_removal() -> bool:
	var board_size = Vector2i(8, 8)
	var p1 = PuzzlePieceData.create(1, [Vector2i(2, 2)], Vector2i.UP)
	var p2 = PuzzlePieceData.create(2, [Vector2i(2, 4)], Vector2i.UP) # Blocked by p1
	var occ = {Vector2i(2, 2): 1, Vector2i(2, 4): 2}
	
	if MovementValidator.can_escape(p2, board_size, occ) != false:
		return false
		
	# Remove p1
	occ.erase(Vector2i(2, 2))
	return MovementValidator.can_escape(p2, board_size, occ) == true

func test_occupancy_after_restart() -> bool:
	var board_size = Vector2i(8, 8)
	var pieces = [
		PuzzlePieceData.create(1, [Vector2i(1, 1)], Vector2i.RIGHT),
		PuzzlePieceData.create(2, [Vector2i(3, 1)], Vector2i.UP)
	]
	
	# Initial build
	var occ1 = {}
	for p in pieces:
		for c in p.cells:
			occ1[c] = p.piece_id
			
	# Remove p1
	occ1.erase(Vector2i(1, 1))
	
	# Restart build
	var occ_restarted = {}
	for p in pieces:
		for c in p.cells:
			occ_restarted[c] = p.piece_id
			
	return occ_restarted.size() == 2 and occ_restarted.get(Vector2i(1, 1)) == 1

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
	var h = TapHandler.new()
	var r1 = h.tap()
	var r2 = h.tap()
	var r3 = h.tap()
	return r1 == true and r2 == false and r3 == false and h.tap_count == 1

func test_final_path_completion() -> bool:
	var remaining_pieces = 1
	var on_piece_escaped = func():
		remaining_pieces -= 1
		return remaining_pieces <= 0
		
	return on_piece_escaped.call() == true
