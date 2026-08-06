extends SceneTree

var board_bounds := Rect2i(0, 0, 8, 8)
var max_pieces = 12

func _init():
	for i in range(5, 11):
		var data = generate_level(i + 3)
		var file = FileAccess.open("res://data/level%d.json" % i, FileAccess.WRITE)
		file.store_string(JSON.stringify(data, "  "))
		print("Generated level %d" % i)
	quit()

func generate_level(num_pieces: int) -> Dictionary:
	var pieces = []
	var occupied = {}
	
	# Try to add pieces backwards
	for i in range(num_pieces):
		var p = try_add_piece(occupied)
		if p != null:
			pieces.append(p)
			for c in p["cells"]:
				occupied[c] = pieces.size()
	
	# Format
	var save_pieces = []
	for p in pieces:
		var cells = []
		for c in p["cells"]:
			cells.append([c.x, c.y])
		save_pieces.append({
			"cells": cells,
			"direction": [p["direction"].x, p["direction"].y]
		})
		
	return {
		"width": board_bounds.size.x,
		"height": board_bounds.size.y,
		"lives": 3,
		"pieces": save_pieces
	}

func try_add_piece(occupied: Dictionary):
	var dirs = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
	
	for attempt in range(100):
		var start_cell = Vector2i(randi() % board_bounds.size.x, randi() % board_bounds.size.y)
		if occupied.has(start_cell):
			continue
			
		var dir = dirs[randi() % 4]
		
		# Trace backwards from exit! 
		# Wait, a piece added backwards needs a clear exit path AT THE TIME IT IS ADDED.
		# That means its exit path must be free of any CURRENTLY occupied cells.
		var length = (randi() % 3) + 2
		var cells: Array[Vector2i] = []
		var current = start_cell
		
		# First check if the exit from start_cell is clear
		var exit_clear = true
		var test = start_cell + dir
		while board_bounds.has_point(test):
			if occupied.has(test):
				exit_clear = false
				break
			test += dir
			
		if not exit_clear:
			continue
			
		# Now build the piece backwards (opposite of dir, or turning)
		cells.append(start_cell)
		var build_dir = -dir
		var valid = true
		
		for step in range(length - 1):
			current += build_dir
			if not board_bounds.has_point(current) or occupied.has(current):
				valid = false
				break
			cells.push_front(current)
			# optionally turn
			if randf() > 0.5:
				if build_dir.x != 0:
					build_dir = Vector2i(0, 1) if randf() > 0.5 else Vector2i(0, -1)
				else:
					build_dir = Vector2i(1, 0) if randf() > 0.5 else Vector2i(-1, 0)
					
		if valid and cells.size() == length:
			return {"cells": cells, "direction": dir}
			
	return null
