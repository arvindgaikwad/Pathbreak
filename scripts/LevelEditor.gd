extends Node2D

const PuzzlePieceScene: PackedScene = preload("res://scenes/game/puzzle_piece.tscn")
const PuzzlePieceDataScript = preload("res://scripts/gameplay/puzzle_piece_data.gd")
const PathVisualGeometryScript = preload("res://scripts/gameplay/path_visual_geometry.gd")
const LevelDataValidatorScript = preload("res://scripts/gameplay/level_data_validator.gd")
const LevelSolverScript = preload("res://scripts/gameplay/level_solver.gd")
const EditorGridScript = preload("res://scripts/editor/editor_grid.gd")
const LevelStudioPreviewSessionScript = preload("res://scripts/editor/level_studio_preview_session.gd")

const PREVIEW_SCENE := "res://scenes/editor/level_preview_screen.tscn"
const VALID_DIFFICULTIES := ["Easy", "Normal", "Hard"]

var board_bounds := Rect2i(0, 0, 8, 8)
var grid_size := 64.0
var pieces_data: Array[Dictionary] = []
var current_path: Array[Vector2i] = []
var is_drawing := false
var level_id: int = 6
var difficulty: String = "Normal"
var starting_lives: int = 3

@onready var grid_dots: Node2D = $BoardPivot/GridDots
@onready var board_pivot: Node2D = $BoardPivot
@onready var validate_label: Label = $UI/Sidebar/ValidateLabel
@onready var metrics_label: Label = $UI/Sidebar/MetricsLabel
@onready var level_spin: SpinBox = $UI/TopPanel/LevelSpin
@onready var lives_spin: SpinBox = $UI/TopPanel/LivesSpin
@onready var meta_summary: Label = $UI/TopPanel/MetaSummary
@onready var preview_button: Button = $UI/Sidebar/PreviewButton

func _ready() -> void:
	grid_dots.set_script(EditorGridScript)
	grid_dots.update_grid(board_bounds, grid_size)

	$UI/Sidebar/SaveButton.pressed.connect(_on_save_pressed)
	$UI/Sidebar/LoadButton.pressed.connect(_on_load_pressed)
	$UI/Sidebar/ClearButton.pressed.connect(_on_clear_pressed)
	$UI/Sidebar/DeleteButton.pressed.connect(_on_delete_pressed)
	$UI/Sidebar/ValidateButton.pressed.connect(_on_validate_pressed)
	preview_button.pressed.connect(_on_preview_pressed)

	$UI/Sidebar/BtnUP.pressed.connect(func() -> void: _set_last_dir(Vector2i.UP))
	$UI/Sidebar/BtnDOWN.pressed.connect(func() -> void: _set_last_dir(Vector2i.DOWN))
	$UI/Sidebar/BtnLEFT.pressed.connect(func() -> void: _set_last_dir(Vector2i.LEFT))
	$UI/Sidebar/BtnRIGHT.pressed.connect(func() -> void: _set_last_dir(Vector2i.RIGHT))

	level_spin.value_changed.connect(_on_level_value_changed)
	lives_spin.value_changed.connect(_on_lives_value_changed)
	$UI/TopPanel/Board6.pressed.connect(func() -> void: _set_board_size(6))
	$UI/TopPanel/Board7.pressed.connect(func() -> void: _set_board_size(7))
	$UI/TopPanel/Board8.pressed.connect(func() -> void: _set_board_size(8))
	$UI/TopPanel/Board9.pressed.connect(func() -> void: _set_board_size(9))
	$UI/TopPanel/DifficultyEasy.pressed.connect(func() -> void: _set_difficulty("Easy"))
	$UI/TopPanel/DifficultyNormal.pressed.connect(func() -> void: _set_difficulty("Normal"))
	$UI/TopPanel/DifficultyHard.pressed.connect(func() -> void: _set_difficulty("Hard"))

	var return_state: Dictionary = LevelStudioPreviewSessionScript.get_editor_state()
	if not return_state.is_empty():
		_restore_editor_state(return_state)
		LevelStudioPreviewSessionScript.clear()
		_set_validation_message("Returned from preview. Analyze after edits.", true)
	else:
		_sync_metadata_controls()
		_clear_metrics()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var cell := _mouse_to_grid(event.position)
			if board_bounds.has_point(cell):
				is_drawing = true
				current_path = [cell]
				queue_redraw()
		else:
			_finish_current_path()
	elif event is InputEventMouseMotion and is_drawing:
		var cell := _mouse_to_grid(event.position)
		if not board_bounds.has_point(cell):
			return
		if current_path.is_empty():
			current_path.append(cell)
			queue_redraw()
			return
		var last_cell: Vector2i = current_path[-1]
		if cell == last_cell or current_path.has(cell):
			return
		var difference := cell - last_cell
		if absi(difference.x) + absi(difference.y) == 1:
			current_path.append(cell)
			queue_redraw()

func _finish_current_path() -> void:
	if not is_drawing:
		return
	is_drawing = false
	if current_path.size() < 2:
		current_path.clear()
		queue_redraw()
		_set_validation_message("Draw at least two adjacent cells.", false)
		return
	var path_errors := PathVisualGeometryScript.validate_ordered_cells(current_path)
	if not path_errors.is_empty():
		current_path.clear()
		queue_redraw()
		_set_validation_message(path_errors[0], false)
		return
	var direction := PathVisualGeometryScript.direction_from_cells(current_path)
	pieces_data.append({
		"cells": current_path.duplicate(),
		"direction": direction
	})
	current_path.clear()
	_refresh_pieces()
	_mark_analysis_dirty()

func _mouse_to_grid(screen_position: Vector2) -> Vector2i:
	var local_position := screen_position - board_pivot.position
	var offset_x := -(board_bounds.size.x * grid_size) / 2.0
	var offset_y := -(board_bounds.size.y * grid_size) / 2.0
	var grid_position := local_position - Vector2(offset_x, offset_y)
	return Vector2i(floori(grid_position.x / grid_size), floori(grid_position.y / grid_size))

func _refresh_pieces() -> void:
	for child in board_pivot.get_children():
		if child is PuzzlePiece:
			child.queue_free()

	var piece_id := 1
	for piece_dictionary in pieces_data:
		var cells: Array[Vector2i] = piece_dictionary["cells"]
		var direction := PathVisualGeometryScript.direction_from_cells(cells)
		piece_dictionary["direction"] = direction
		var piece_data := PuzzlePieceDataScript.create(piece_id, cells, direction)
		var piece := PuzzlePieceScene.instantiate() as PuzzlePiece
		if piece == null:
			push_error("PuzzlePiece scene does not use the PuzzlePiece script.")
			continue
		piece.init_from_data(piece_data, grid_size)
		var offset_x := -(board_bounds.size.x * grid_size) / 2.0
		var offset_y := -(board_bounds.size.y * grid_size) / 2.0
		piece.position = Vector2(offset_x, offset_y)
		board_pivot.add_child(piece)
		piece_id += 1
	queue_redraw()

func _draw() -> void:
	if current_path.is_empty():
		return
	var offset_x := board_pivot.position.x - (board_bounds.size.x * grid_size) / 2.0
	var offset_y := board_pivot.position.y - (board_bounds.size.y * grid_size) / 2.0
	var points := PackedVector2Array()
	for cell in current_path:
		points.append(
			Vector2(
				offset_x + cell.x * grid_size + grid_size * 0.5,
				offset_y + cell.y * grid_size + grid_size * 0.5
			)
		)
	if points.size() > 1:
		draw_polyline(points, Color(0.8, 0.2, 0.2, 0.5), 16.0)
	else:
		draw_circle(points[0], 16.0, Color(0.8, 0.2, 0.2, 0.5))

func _set_last_dir(requested_direction: Vector2i) -> void:
	if pieces_data.is_empty():
		return
	var cells: Array[Vector2i] = pieces_data[-1]["cells"]
	if cells.size() < 2:
		return
	var end_direction := PathVisualGeometryScript.direction_from_cells(
		cells,
		PathVisualGeometry.HeadEndpoint.END
	)
	var start_direction := PathVisualGeometryScript.direction_from_cells(
		cells,
		PathVisualGeometry.HeadEndpoint.START
	)
	if requested_direction == end_direction:
		pieces_data[-1]["direction"] = end_direction
	elif requested_direction == start_direction:
		cells.reverse()
		pieces_data[-1]["cells"] = cells
		pieces_data[-1]["direction"] = requested_direction
	else:
		_set_validation_message(
			"Direction must follow the first or final path segment.",
			false
		)
		return
	_refresh_pieces()
	_mark_analysis_dirty()

func _on_clear_pressed() -> void:
	pieces_data.clear()
	_refresh_pieces()
	_mark_analysis_dirty()

func _on_delete_pressed() -> void:
	if not pieces_data.is_empty():
		pieces_data.pop_back()
	_refresh_pieces()
	_mark_analysis_dirty()

func _on_level_value_changed(value: float) -> void:
	level_id = maxi(int(value), 1)
	_sync_metadata_controls()
	_mark_analysis_dirty()

func _on_lives_value_changed(value: float) -> void:
	starting_lives = maxi(int(value), 1)
	_sync_metadata_controls()
	_mark_analysis_dirty()

func _set_difficulty(value: String) -> void:
	if value not in VALID_DIFFICULTIES:
		return
	difficulty = value
	_sync_metadata_controls()
	_mark_analysis_dirty()

func _set_board_size(size: int) -> void:
	var new_bounds := Rect2i(0, 0, size, size)
	for piece_dictionary in pieces_data:
		var cells: Array[Vector2i] = piece_dictionary["cells"]
		for cell in cells:
			if not new_bounds.has_point(cell):
				_set_validation_message("Cannot shrink board: an existing path would be outside it.", false)
				return
	board_bounds = new_bounds
	grid_dots.update_grid(board_bounds, grid_size)
	_refresh_pieces()
	_sync_metadata_controls()
	_mark_analysis_dirty()

func _sync_metadata_controls() -> void:
	if level_spin != null:
		level_spin.set_value_no_signal(level_id)
	if lives_spin != null:
		lives_spin.set_value_no_signal(starting_lives)
	$UI/TopPanel/Board6.disabled = board_bounds.size == Vector2i(6, 6)
	$UI/TopPanel/Board7.disabled = board_bounds.size == Vector2i(7, 7)
	$UI/TopPanel/Board8.disabled = board_bounds.size == Vector2i(8, 8)
	$UI/TopPanel/Board9.disabled = board_bounds.size == Vector2i(9, 9)
	$UI/TopPanel/DifficultyEasy.disabled = difficulty == "Easy"
	$UI/TopPanel/DifficultyNormal.disabled = difficulty == "Normal"
	$UI/TopPanel/DifficultyHard.disabled = difficulty == "Hard"
	meta_summary.text = "L%d • %dx%d • %s • %d lives" % [
		level_id,
		board_bounds.size.x,
		board_bounds.size.y,
		difficulty,
		starting_lives
	]
	$UI/Sidebar/SaveButton.text = "Export L%d Draft" % level_id
	preview_button.text = "Preview L%d" % level_id

func _build_level() -> PuzzleLevelData:
	var level := PuzzleLevelData.new()
	level.level_id = level_id
	level.board_size = board_bounds.size
	level.difficulty = difficulty
	level.starting_lives = starting_lives
	for piece_index in range(pieces_data.size()):
		var piece_dictionary: Dictionary = pieces_data[piece_index]
		var cells: Array[Vector2i] = piece_dictionary["cells"]
		var direction := PathVisualGeometryScript.direction_from_cells(cells)
		level.pieces.append(PuzzlePieceDataScript.create(piece_index + 1, cells, direction))
	return level

func _analyze_for_action(action_name: String) -> Dictionary:
	var level := _build_level()
	var errors: PackedStringArray = LevelDataValidatorScript.validate(level)
	if not errors.is_empty():
		_show_validation_errors(errors)
		return {"ok": false}
	var report: Dictionary = LevelSolverScript.analyze(level)
	_show_metrics(report)
	if int(report["opening_move_count"]) <= 0:
		_set_validation_message("%s blocked: level has no opening move." % action_name, false)
		return {"ok": false, "report": report}
	if not bool(report["solvable"]):
		_set_validation_message("%s blocked: solver cannot clear this level." % action_name, false)
		return {"ok": false, "report": report}
	return {"ok": true, "level": level, "report": report}

func _on_preview_pressed() -> void:
	var analysis := _analyze_for_action("Preview")
	if not bool(analysis.get("ok", false)):
		return
	var level: PuzzleLevelData = analysis["level"]
	LevelStudioPreviewSessionScript.begin_preview(level, _build_editor_state())
	get_tree().change_scene_to_file(PREVIEW_SCENE)

func _on_save_pressed() -> void:
	var analysis := _analyze_for_action("Export")
	if not bool(analysis.get("ok", false)):
		return
	var level: PuzzleLevelData = analysis["level"]
	var save_data := _serialize_level(level)
	var file := FileAccess.open("res://data/editor_level.json", FileAccess.WRITE)
	if file == null:
		_set_validation_message("Could not write editor_level.json.", false)
		return
	file.store_string(JSON.stringify(save_data, "  "))
	_set_validation_message("Validated and exported L%d draft JSON." % level_id, true)
	_show_metrics(analysis["report"])

func _serialize_level(level: PuzzleLevelData) -> Dictionary:
	var save_data: Dictionary = {
		"level_id": level.level_id,
		"width": level.board_size.x,
		"height": level.board_size.y,
		"difficulty": level.difficulty,
		"lives": level.starting_lives,
		"pieces": []
	}
	for piece in level.pieces:
		if piece == null:
			continue
		var serialized_cells: Array = []
		for cell in piece.cells:
			serialized_cells.append([cell.x, cell.y])
		save_data["pieces"].append({
			"cells": serialized_cells,
			"direction": [piece.exit_direction.x, piece.exit_direction.y],
			"head_endpoint": "end"
		})
	return save_data

func _on_load_pressed() -> void:
	var path := "res://data/editor_level.json"
	if not FileAccess.file_exists(path):
		_set_validation_message("editor_level.json was not found.", false)
		return
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_set_validation_message("Could not open editor_level.json.", false)
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		_set_validation_message("Invalid editor level JSON.", false)
		return
	var data: Dictionary = parsed
	level_id = maxi(int(data.get("level_id", level_id)), 1)
	difficulty = str(data.get("difficulty", difficulty))
	if difficulty not in VALID_DIFFICULTIES:
		difficulty = "Normal"
	starting_lives = maxi(int(data.get("lives", 3)), 1)
	board_bounds.size = Vector2i(int(data.get("width", 8)), int(data.get("height", 8)))
	grid_dots.update_grid(board_bounds, grid_size)
	pieces_data.clear()
	var rejected := 0
	for raw_piece in data.get("pieces", []):
		if not raw_piece is Dictionary:
			rejected += 1
			continue
		var cells: Array[Vector2i] = []
		for raw_cell in raw_piece.get("cells", []):
			if raw_cell is Array and raw_cell.size() >= 2:
				cells.append(Vector2i(int(raw_cell[0]), int(raw_cell[1])))
		var path_errors := PathVisualGeometryScript.validate_ordered_cells(cells)
		if not path_errors.is_empty():
			rejected += 1
			continue
		var direction := PathVisualGeometryScript.direction_from_cells(cells)
		var legacy_direction_data: Array = raw_piece.get("direction", [])
		if legacy_direction_data.size() >= 2:
			var legacy_direction := Vector2i(
				int(legacy_direction_data[0]),
				int(legacy_direction_data[1])
			)
			var endpoint := PathVisualGeometryScript.legacy_head_endpoint(cells, legacy_direction)
			if endpoint == PathVisualGeometry.HeadEndpoint.START:
				cells.reverse()
				direction = legacy_direction
			elif endpoint < 0:
				rejected += 1
				continue
		pieces_data.append({"cells": cells, "direction": direction})
	_refresh_pieces()
	_sync_metadata_controls()
	_clear_metrics()
	if rejected > 0:
		_set_validation_message("Loaded with %d ambiguous path(s) rejected." % rejected, false)
	else:
		_set_validation_message("Loaded canonical draft. Press Analyze.", true)

func _build_editor_state() -> Dictionary:
	var serialized_pieces: Array = []
	for piece_dictionary in pieces_data:
		var serialized_cells: Array = []
		var cells: Array[Vector2i] = piece_dictionary["cells"]
		for cell in cells:
			serialized_cells.append([cell.x, cell.y])
		serialized_pieces.append({"cells": serialized_cells})
	return {
		"level_id": level_id,
		"difficulty": difficulty,
		"lives": starting_lives,
		"board_size": [board_bounds.size.x, board_bounds.size.y],
		"pieces": serialized_pieces
	}

func _restore_editor_state(state: Dictionary) -> void:
	level_id = maxi(int(state.get("level_id", 6)), 1)
	difficulty = str(state.get("difficulty", "Normal"))
	if difficulty not in VALID_DIFFICULTIES:
		difficulty = "Normal"
	starting_lives = maxi(int(state.get("lives", 3)), 1)
	var size_data: Array = state.get("board_size", [8, 8])
	if size_data.size() >= 2:
		board_bounds.size = Vector2i(int(size_data[0]), int(size_data[1]))
	pieces_data.clear()
	for raw_piece in state.get("pieces", []):
		if not raw_piece is Dictionary:
			continue
		var cells: Array[Vector2i] = []
		for raw_cell in raw_piece.get("cells", []):
			if raw_cell is Array and raw_cell.size() >= 2:
				cells.append(Vector2i(int(raw_cell[0]), int(raw_cell[1])))
		if PathVisualGeometryScript.validate_ordered_cells(cells).is_empty():
			pieces_data.append({
				"cells": cells,
				"direction": PathVisualGeometryScript.direction_from_cells(cells)
			})
	grid_dots.update_grid(board_bounds, grid_size)
	_refresh_pieces()
	_sync_metadata_controls()
	_clear_metrics()

func _on_validate_pressed() -> void:
	var level := _build_level()
	var errors: PackedStringArray = LevelDataValidatorScript.validate(level)
	if not errors.is_empty():
		_show_validation_errors(errors)
		return

	var report: Dictionary = LevelSolverScript.analyze(level)
	_show_metrics(report)
	if int(report["opening_move_count"]) <= 0:
		_set_validation_message("Invalid: no opening move.", false)
	elif not bool(report["solvable"]):
		_set_validation_message("Invalid: solver cannot clear level.", false)
	else:
		_set_validation_message("Valid and solvable. Ready to preview.", true)

func _show_validation_errors(errors: PackedStringArray) -> void:
	_clear_metrics()
	if errors.is_empty():
		return
	_set_validation_message("Invalid: %s" % errors[0], false)
	if errors.size() > 1:
		metrics_label.text = "%d more validation error(s)." % (errors.size() - 1)

func _show_metrics(report: Dictionary) -> void:
	var solution_text := str(report["solution_count"])
	if bool(report["solution_count_capped"]):
		solution_text += "+"
	metrics_label.text = (
		"Pieces %d | Open %d | Solutions %s\nForced states %d | Branch states %d | Forced chain %d" % [
			int(report["piece_count"]),
			int(report["opening_move_count"]),
			solution_text,
			int(report["forced_state_count"]),
			int(report["branch_state_count"]),
			int(report["longest_forced_chain"])
		]
	)

func _clear_metrics() -> void:
	if metrics_label != null:
		metrics_label.text = "Draw paths tail → head, then Analyze."

func _mark_analysis_dirty() -> void:
	_set_validation_message("Analysis needed.", true)
	_clear_metrics()

func _set_validation_message(message: String, positive: bool) -> void:
	validate_label.text = message
	validate_label.add_theme_color_override(
		"font_color",
		Color(0.2, 0.8, 0.2) if positive else Color(0.8, 0.2, 0.2)
	)
