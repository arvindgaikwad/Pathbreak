class_name LevelSolver
extends RefCounted

const DEFAULT_SOLUTION_CAP := 1000000

static func get_initial_escapable_piece_ids(level: PuzzleLevelData) -> Array[int]:
	return _get_escapable_piece_ids(level, _all_piece_ids(level))

static func count_solutions(level: PuzzleLevelData, cap: int = DEFAULT_SOLUTION_CAP) -> int:
	if level == null or level.pieces.is_empty():
		return 0
	var memo: Dictionary = {}
	return _count_from_state(level, _all_piece_ids(level), memo, maxi(cap, 1))

static func find_one_solution(level: PuzzleLevelData) -> Array[int]:
	var solution: Array[int] = []
	if level == null or level.pieces.is_empty():
		return solution
	_find_solution_from_state(level, _all_piece_ids(level), solution)
	return solution

static func has_reachable_dead_end(level: PuzzleLevelData) -> bool:
	if level == null or level.pieces.is_empty():
		return true
	var visited: Dictionary = {}
	return _state_has_dead_end(level, _all_piece_ids(level), visited)

static func _all_piece_ids(level: PuzzleLevelData) -> Array[int]:
	var piece_ids: Array[int] = []
	if level == null:
		return piece_ids
	for piece in level.pieces:
		if piece != null:
			piece_ids.append(piece.piece_id)
	piece_ids.sort()
	return piece_ids

static func _get_escapable_piece_ids(level: PuzzleLevelData, remaining_ids: Array[int]) -> Array[int]:
	var escapable_ids: Array[int] = []
	if level == null or remaining_ids.is_empty():
		return escapable_ids

	var remaining_lookup: Dictionary = {}
	for piece_id in remaining_ids:
		remaining_lookup[piece_id] = true

	var occupancy: Dictionary = {}
	for piece in level.pieces:
		if piece == null or not remaining_lookup.has(piece.piece_id):
			continue
		for cell in piece.cells:
			occupancy[cell] = piece.piece_id

	for piece in level.pieces:
		if piece == null or not remaining_lookup.has(piece.piece_id):
			continue
		if MovementValidator.can_escape(piece, level.board_size, occupancy):
			escapable_ids.append(piece.piece_id)

	escapable_ids.sort()
	return escapable_ids

static func _count_from_state(
	level: PuzzleLevelData,
	remaining_ids: Array[int],
	memo: Dictionary,
	cap: int
) -> int:
	if remaining_ids.is_empty():
		return 1

	var state_key := _state_key(remaining_ids)
	if memo.has(state_key):
		return int(memo[state_key])

	var escapable_ids := _get_escapable_piece_ids(level, remaining_ids)
	if escapable_ids.is_empty():
		memo[state_key] = 0
		return 0

	var total := 0
	for piece_id in escapable_ids:
		var next_ids: Array[int] = remaining_ids.duplicate()
		next_ids.erase(piece_id)
		total += _count_from_state(level, next_ids, memo, cap)
		if total >= cap:
			total = cap
			break

	memo[state_key] = total
	return total

static func _find_solution_from_state(
	level: PuzzleLevelData,
	remaining_ids: Array[int],
	solution: Array[int]
) -> bool:
	if remaining_ids.is_empty():
		return true

	for piece_id in _get_escapable_piece_ids(level, remaining_ids):
		var next_ids: Array[int] = remaining_ids.duplicate()
		next_ids.erase(piece_id)
		solution.append(piece_id)
		if _find_solution_from_state(level, next_ids, solution):
			return true
		solution.pop_back()

	return false

static func _state_has_dead_end(
	level: PuzzleLevelData,
	remaining_ids: Array[int],
	visited: Dictionary
) -> bool:
	if remaining_ids.is_empty():
		return false

	var state_key := _state_key(remaining_ids)
	if visited.has(state_key):
		return false
	visited[state_key] = true

	var escapable_ids := _get_escapable_piece_ids(level, remaining_ids)
	if escapable_ids.is_empty():
		return true

	for piece_id in escapable_ids:
		var next_ids: Array[int] = remaining_ids.duplicate()
		next_ids.erase(piece_id)
		if _state_has_dead_end(level, next_ids, visited):
			return true

	return false

static func _state_key(remaining_ids: Array[int]) -> String:
	var parts := PackedStringArray()
	for piece_id in remaining_ids:
		parts.append(str(piece_id))
	return ",".join(parts)
