extends SceneTree

var BoardScene: PackedScene = preload("res://scenes/game/board.tscn")

func _init() -> void:
	print("--- Running Pathbreak Satisfaction Feedback Test Suite ---")
	var passed := test_newly_freed_dependency_detection()
	print("Satisfaction feedback: %s" % ("1/1 passed" if passed else "0/1 passed"))
	quit(0 if passed else 1)

func test_newly_freed_dependency_detection() -> bool:
	var board = BoardScene.instantiate()
	root.add_child(board)

	var level := PuzzleLevelData.new()
	level.level_id = 9001
	level.board_size = Vector2i(4, 4)
	level.difficulty = "Test"

	var blocked_piece := PuzzlePieceData.create(
		1,
		[[0, 1], [1, 1]],
		Vector2i.RIGHT
	)
	var blocker_piece := PuzzlePieceData.create(
		2,
		[[2, 1], [2, 2]],
		Vector2i.DOWN
	)
	level.pieces = [blocked_piece, blocker_piece]
	board.setup_level(level)

	var before: PackedInt32Array = board.get_escapable_piece_ids()
	if before.size() != 1 or before[0] != 2:
		push_error("Expected only blocker piece 2 to be escapable before removal; got %s." % before)
		board.queue_free()
		return false

	var runtime_blocker: PuzzlePiece = board.pieces[1]
	board.remove_piece_occupancy(runtime_blocker)
	runtime_blocker.is_removed = true

	var newly_freed: Array[PuzzlePiece] = board.get_newly_escapable_pieces(before)
	var passed := newly_freed.size() == 1 and newly_freed[0].piece_id == 1
	if not passed:
		var ids := PackedInt32Array()
		for piece in newly_freed:
			ids.append(piece.piece_id)
		push_error("Expected piece 1 to become newly escapable; got %s." % ids)

	board.queue_free()
	return passed
