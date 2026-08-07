extends Node2D

var board_bounds := Rect2i(0, 0, 8, 8)
var cell_size := 64.0

const BOARD_COLOR := Color("#FFFFFF")
const GRID_DOT_COLOR := Color("#DDE3EC")
const SHADOW_COLOR := Color(0.1, 0.12, 0.18, 0.06)
const BOARD_PADDING := 12.0

func update_grid(bounds: Rect2i, new_cell_size: float) -> void:
	board_bounds = bounds
	cell_size = new_cell_size
	queue_redraw()

func _draw() -> void:
	var board_width := board_bounds.size.x * cell_size
	var board_height := board_bounds.size.y * cell_size
	var offset := Vector2(-board_width * 0.5, -board_height * 0.5)

	var shadow_rect := Rect2(
		offset - Vector2(8.0, 4.0),
		Vector2(board_width + 16.0, board_height + 24.0)
	)
	var board_rect := Rect2(
		offset - Vector2(BOARD_PADDING, BOARD_PADDING),
		Vector2(board_width, board_height) + Vector2.ONE * BOARD_PADDING * 2.0
	)
	_draw_rounded_rect(shadow_rect, SHADOW_COLOR, 28)
	_draw_rounded_rect(board_rect, BOARD_COLOR, 28)

	for x in range(board_bounds.size.x + 1):
		for y in range(board_bounds.size.y + 1):
			var point := offset + Vector2(x * cell_size, y * cell_size)
			draw_circle(point, 3.5, GRID_DOT_COLOR)

func _draw_rounded_rect(rect: Rect2, color: Color, radius: int) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	draw_style_box(style, rect)
