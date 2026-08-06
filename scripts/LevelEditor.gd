extends Node2D

var PuzzlePieceScene = preload("res://scenes/game/puzzle_piece.tscn")

var board_bounds := Rect2i(0, 0, 8, 8)
var grid_size := 64.0

var pieces_data: Array = []
var current_path: Array[Vector2i] = []
var is_drawing := false

@onready var grid_dots = $BoardPivot/GridDots
@onready var board_pivot = $BoardPivot
@onready var validate_label = $UI/Sidebar/ValidateLabel

func _ready():
	grid_dots.set_script(preload("res://scripts/gameplay/board_manager.gd"))
	grid_dots.update_grid(board_bounds, grid_size)
	
	$UI/Sidebar/SaveButton.pressed.connect(_on_save_pressed)
	$UI/Sidebar/LoadButton.pressed.connect(_on_load_pressed)
	$UI/Sidebar/ClearButton.pressed.connect(_on_clear_pressed)
	$UI/Sidebar/DeleteButton.pressed.connect(_on_delete_pressed)
	$UI/Sidebar/ValidateButton.pressed.connect(_on_validate_pressed)
	
	$UI/Sidebar/BtnUP.pressed.connect(func(): _set_last_dir(Vector2i(0, -1)))
	$UI/Sidebar/BtnDOWN.pressed.connect(func(): _set_last_dir(Vector2i(0, 1)))
	$UI/Sidebar/BtnLEFT.pressed.connect(func(): _set_last_dir(Vector2i(-1, 0)))
	$UI/Sidebar/BtnRIGHT.pressed.connect(func(): _set_last_dir(Vector2i(1, 0)))

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var cell = _mouse_to_grid(event.position)
			if board_bounds.has_point(cell):
				is_drawing = true
				current_path = [cell]
				queue_redraw()
		else:
			if is_drawing:
				is_drawing = false
				if current_path.size() > 0:
					# infer direction from last two cells, or default to right
					var dir = Vector2i(1, 0)
					if current_path.size() > 1:
						var diff = current_path[-1] - current_path[-2]
						dir = diff
					pieces_data.append({
						"cells": current_path.duplicate(),
						"direction": dir
					})
					current_path.clear()
					_refresh_pieces()
					validate_label.text = "Valid: ?"

	elif event is InputEventMouseMotion and is_drawing:
		var cell = _mouse_to_grid(event.position)
		if board_bounds.has_point(cell):
			if current_path.is_empty():
				current_path.append(cell)
			else:
				var last_cell = current_path[-1]
				# Ensure adjacent and not already in path
				if cell != last_cell and not current_path.has(cell):
					var diff = cell - last_cell
					if abs(diff.x) + abs(diff.y) == 1: # adjacent
						current_path.append(cell)
						queue_redraw()

func _mouse_to_grid(pos: Vector2) -> Vector2i:
	var local_pos = pos - board_pivot.position
	var offset_x = -(board_bounds.size.x * grid_size) / 2.0
	var offset_y = -(board_bounds.size.y * grid_size) / 2.0
	
	var grid_pos = local_pos - Vector2(offset_x, offset_y)
	return Vector2i(floor(grid_pos.x / grid_size), floor(grid_pos.y / grid_size))

func _refresh_pieces():
	for child in board_pivot.get_children():
		if child is PuzzlePiece:
			child.queue_free()
			
	var pid = 1
	for p_data in pieces_data:
		var piece = PuzzlePieceScene.instantiate()
		var p_dir = p_data["direction"]
		piece.init_piece(pid, p_data["cells"], p_dir, grid_size)
		# We need to offset piece inside BoardPivot
		var offset_x = -(board_bounds.size.x * grid_size) / 2.0
		var offset_y = -(board_bounds.size.y * grid_size) / 2.0
		piece.position = Vector2(offset_x, offset_y)
		board_pivot.add_child(piece)
		pid += 1
		
	queue_redraw()

func _draw():
	if current_path.size() > 0:
		var offset_x = -(board_bounds.size.x * grid_size) / 2.0
		var offset_y = -(board_bounds.size.y * grid_size) / 2.0
		var points = PackedVector2Array()
		for cell in current_path:
			var p = Vector2(offset_x + cell.x * grid_size + grid_size/2, offset_y + cell.y * grid_size + grid_size/2)
			points.append(p)
		
		if points.size() > 1:
			draw_polyline(points, Color(0.8, 0.2, 0.2, 0.5), 16.0)
		elif points.size() == 1:
			draw_circle(points[0], 16.0, Color(0.8, 0.2, 0.2, 0.5))

func _set_last_dir(dir: Vector2i):
	if pieces_data.size() > 0:
		pieces_data[-1]["direction"] = dir
		_refresh_pieces()
		validate_label.text = "Valid: ?"

func _on_clear_pressed():
	pieces_data.clear()
	_refresh_pieces()
	validate_label.text = "Valid: ?"

func _on_delete_pressed():
	if pieces_data.size() > 0:
		pieces_data.pop_back()
		_refresh_pieces()
		validate_label.text = "Valid: ?"

func _on_save_pressed():
	var save_data = {
		"width": board_bounds.size.x,
		"height": board_bounds.size.y,
		"lives": 3,
		"pieces": []
	}
	for p in pieces_data:
		var cells = []
		for c in p["cells"]:
			cells.append([c.x, c.y])
		save_data["pieces"].append({
			"cells": cells,
			"direction": [p["direction"].x, p["direction"].y]
		})
	
	var file = FileAccess.open("res://data/editor_level.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "  "))
	print("Saved to editor_level.json")

func _on_load_pressed():
	var path = "res://data/editor_level.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		var json = JSON.new()
		if json.parse(content) == OK:
			var data = json.data
			board_bounds.size = Vector2i(data.get("width", 8), data.get("height", 8))
			grid_dots.update_grid(board_bounds, grid_size)
			
			pieces_data.clear()
			for p in data.get("pieces", []):
				var cells: Array[Vector2i] = []
				for c in p["cells"]:
					cells.append(Vector2i(int(c[0]), int(c[1])))
				var dir = Vector2i(int(p["direction"][0]), int(p["direction"][1]))
				pieces_data.append({"cells": cells, "direction": dir})
				
			_refresh_pieces()
			validate_label.text = "Valid: ?"

func _on_validate_pressed():
	var is_solvable = _can_solve()
	if is_solvable:
		validate_label.text = "Valid: Yes!"
		validate_label.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2))
	else:
		validate_label.text = "Valid: NO"
		validate_label.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2))

func _can_solve() -> bool:
	var pieces_copy = pieces_data.duplicate(true)
	var occupied = {}
	var pid = 0
	
	for p in pieces_copy:
		p["id"] = pid
		for c in p["cells"]:
			occupied[c] = pid
		pid += 1
		
	var removed_something = true
	while removed_something and pieces_copy.size() > 0:
		removed_something = false
		for i in range(pieces_copy.size() - 1, -1, -1):
			var p = pieces_copy[i]
			if _can_escape(p, occupied):
				for c in p["cells"]:
					occupied.erase(c)
				pieces_copy.remove_at(i)
				removed_something = true
				
	return pieces_copy.is_empty()

func _can_escape(piece: Dictionary, occupied: Dictionary) -> bool:
	for cell in piece["cells"]:
		var test_cell = cell + piece["direction"]
		while board_bounds.has_point(test_cell):
			var blocker = occupied.get(test_cell)
			if blocker != null and blocker != piece["id"]:
				return false
			test_cell += piece["direction"]
	return true
