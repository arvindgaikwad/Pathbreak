extends Node2D

var PuzzlePieceScene = preload("res://scenes/game/puzzle_piece.tscn")

var board_size := Vector2i(8, 8)
var grid_size := 64.0

var occupancy: Dictionary = {}
var pieces: Array[PuzzlePiece] = []

@onready var pieces_container = $PiecesContainer

const COLOR_BOARD_CARD = Color("#FFFFFF")
const COLOR_SHADOW = Color(0.1, 0.12, 0.18, 0.06)
const COLOR_GRID_DOTS = Color("#DDE3EC")

func _draw():
	var board_w = board_size.x * grid_size
	var board_h = board_size.y * grid_size
	var offset_x = -board_w / 2.0
	var offset_y = -board_h / 2.0
	
	var pad = 28.0
	var card_rect = Rect2(offset_x - pad, offset_y - pad, board_w + pad * 2, board_h + pad * 2)
	
	# Soft drop shadow
	var shadow_rect = card_rect
	shadow_rect.position += Vector2(0, 6)
	_draw_rounded_stylebox(shadow_rect, COLOR_SHADOW, 32)
	
	# Pure White Board Card (matching reference image)
	_draw_rounded_stylebox(card_rect, COLOR_BOARD_CARD, 32)
	
	# Grid dots
	for x in range(board_size.x + 1):
		for y in range(board_size.y + 1):
			var pos = Vector2(offset_x + x * grid_size, offset_y + y * grid_size)
			draw_circle(pos, 3.5, COLOR_GRID_DOTS)

func _draw_rounded_stylebox(rect: Rect2, color: Color, radius: int):
	var style = StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	draw_style_box(style, rect)

func setup_level(lvl_data: PuzzleLevelData):
	clear_board()
	board_size = lvl_data.board_size
	queue_redraw()
	
	var board_w = board_size.x * grid_size
	var board_h = board_size.y * grid_size
	pieces_container.position = Vector2(-board_w / 2.0, -board_h / 2.0)
	
	for piece_d in lvl_data.pieces:
		var p_node = PuzzlePieceScene.instantiate() as PuzzlePiece
		p_node.init_from_data(piece_d, grid_size)
		pieces_container.add_child(p_node)
		pieces.append(p_node)
		
		for c in p_node.cells:
			occupancy[c] = p_node.piece_id

func clear_board():
	occupancy.clear()
	pieces.clear()
	if pieces_container:
		for child in pieces_container.get_children():
			child.queue_free()

func remove_piece_occupancy(piece: PuzzlePiece):
	for c in piece.cells:
		occupancy.erase(c)

func can_piece_escape(piece: PuzzlePiece) -> bool:
	return MovementValidator.can_escape_piece(piece.piece_id, piece.cells, piece.exit_direction, board_size, occupancy)

func update_idle_pulses():
	for p in pieces:
		if is_instance_valid(p) and not p.is_removed:
			p.set_idle_pulse(can_piece_escape(p))
