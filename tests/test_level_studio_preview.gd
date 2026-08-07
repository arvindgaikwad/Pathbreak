extends SceneTree

const PreviewSession = preload("res://scripts/editor/level_studio_preview_session.gd")

func _init() -> void:
	print("--- Running Pathbreak Level Studio Preview Tests ---")
	var tests: Array[Callable] = [
		test_preview_level_round_trip,
		test_editor_state_round_trip
	]
	var passed := 0
	for test_index in range(tests.size()):
		var result: bool = tests[test_index].call()
		print("%s Level Studio preview test %d" % ["PASS" if result else "FAIL", test_index + 1])
		if result:
			passed += 1
	PreviewSession.clear()
	print("Level studio preview: %d/%d passed" % [passed, tests.size()])
	quit(0 if passed == tests.size() else 1)

func test_preview_level_round_trip() -> bool:
	PreviewSession.clear()
	var level := PuzzleLevelData.new()
	level.level_id = 42
	level.board_size = Vector2i(7, 7)
	level.difficulty = "Hard"
	level.starting_lives = 4
	level.pieces.append(PuzzlePieceData.create(
		1,
		[[0, 1], [1, 1], [1, 2]],
		Vector2i.DOWN
	))

	PreviewSession.begin_preview(level, {"level_id": 42})
	var restored: PuzzleLevelData = PreviewSession.get_preview_level()
	if restored == null:
		push_error("Preview session did not restore a level.")
		return false
	var passed := (
		restored.level_id == 42
		and restored.board_size == Vector2i(7, 7)
		and restored.difficulty == "Hard"
		and restored.starting_lives == 4
		and restored.pieces.size() == 1
		and restored.pieces[0].cells == [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
		and restored.pieces[0].exit_direction == Vector2i.DOWN
	)
	if not passed:
		push_error("Preview level changed during round trip.")
	return passed

func test_editor_state_round_trip() -> bool:
	var level := PuzzleLevelData.new()
	level.level_id = 9
	level.board_size = Vector2i(8, 8)
	level.pieces.append(PuzzlePieceData.create(1, [[0, 0], [1, 0]], Vector2i.RIGHT))
	var editor_state := {
		"level_id": 9,
		"difficulty": "Normal",
		"lives": 3,
		"board_size": [8, 8],
		"pieces": [{"cells": [[0, 0], [1, 0]]}]
	}
	PreviewSession.begin_preview(level, editor_state)
	var restored := PreviewSession.get_editor_state()
	if restored != editor_state:
		push_error("Editor state did not survive preview session round trip: %s" % restored)
		return false
	restored["level_id"] = 100
	return int(PreviewSession.get_editor_state()["level_id"]) == 9
