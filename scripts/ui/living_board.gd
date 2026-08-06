extends Control
class_name LivingBoard

const COLOR_CARD := Color("#FFFFFF")
const COLOR_BORDER := Color("#E4E9F0")
const COLOR_SHADOW := Color(0.08, 0.10, 0.16, 0.08)
const COLOR_GRID := Color("#DDE3EC")
const COLOR_PATH := Color("#1B2538")
const COLOR_ACCENT := Color("#3978F6")

const CYCLE_DURATION := 4.0
const HIGHLIGHT_START := 0.55
const ESCAPE_START := 1.10
const ESCAPE_DURATION := 0.80

var elapsed := 0.0
var active_index := 0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	SettingsManager.settings_changed.connect(_on_settings_changed)
	set_process(not SettingsManager.reduce_motion)
	queue_redraw()

func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= CYCLE_DURATION:
		elapsed = fmod(elapsed, CYCLE_DURATION)
		active_index = (active_index + 1) % 3
	queue_redraw()

func _draw() -> void:
	_draw_board_card()
	_draw_grid()

	var paths := _get_paths()
	var directions := [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	for index in range(paths.size()):
		var offset := Vector2.ZERO
		var path_color := COLOR_PATH
		if index == active_index:
			path_color = COLOR_ACCENT
			if not SettingsManager.reduce_motion:
				var escape_progress := clampf(
					(elapsed - ESCAPE_START) / ESCAPE_DURATION,
					0.0,
					1.0
				)
				offset = directions[index] * ease(escape_progress, 1.6) * 150.0
				if elapsed < HIGHLIGHT_START:
					path_color = COLOR_PATH
		_draw_path(paths[index], directions[index], offset, path_color)

func _draw_board_card() -> void:
	var shadow_rect := Rect2(Vector2(8.0, 12.0), size - Vector2(16.0, 20.0))
	var card_rect := Rect2(Vector2(8.0, 6.0), size - Vector2(16.0, 20.0))

	var shadow_style := StyleBoxFlat.new()
	shadow_style.bg_color = COLOR_SHADOW
	shadow_style.corner_radius_top_left = 30
	shadow_style.corner_radius_top_right = 30
	shadow_style.corner_radius_bottom_left = 30
	shadow_style.corner_radius_bottom_right = 30
	draw_style_box(shadow_style, shadow_rect)

	var card_style := StyleBoxFlat.new()
	card_style.bg_color = COLOR_CARD
	card_style.border_color = COLOR_BORDER
	card_style.border_width_left = 1
	card_style.border_width_top = 1
	card_style.border_width_right = 1
	card_style.border_width_bottom = 1
	card_style.corner_radius_top_left = 30
	card_style.corner_radius_top_right = 30
	card_style.corner_radius_bottom_left = 30
	card_style.corner_radius_bottom_right = 30
	draw_style_box(card_style, card_rect)

func _draw_grid() -> void:
	var usable := Rect2(Vector2(54.0, 38.0), size - Vector2(108.0, 88.0))
	for column in range(7):
		for row in range(4):
			var point := Vector2(
				usable.position.x + (usable.size.x / 6.0) * float(column),
				usable.position.y + (usable.size.y / 3.0) * float(row)
			)
			draw_circle(point, 3.0, COLOR_GRID)

func _get_paths() -> Array[PackedVector2Array]:
	var center := size * 0.5
	return [
		PackedVector2Array([
			center + Vector2(-150.0, -42.0),
			center + Vector2(-82.0, -42.0),
			center + Vector2(-18.0, -42.0)
		]),
		PackedVector2Array([
			center + Vector2(78.0, -62.0),
			center + Vector2(78.0, -4.0),
			center + Vector2(78.0, 56.0)
		]),
		PackedVector2Array([
			center + Vector2(135.0, 58.0),
			center + Vector2(72.0, 58.0),
			center + Vector2(12.0, 58.0)
		])
	]

func _draw_path(
	points: PackedVector2Array,
	direction: Vector2,
	offset: Vector2,
	color: Color
) -> void:
	var shifted := PackedVector2Array()
	for point in points:
		shifted.append(point + offset)

	draw_polyline(shifted, color, 13.0, true)
	draw_circle(shifted[0], 8.0, color)

	var tip := shifted[-1] + direction * 16.0
	var side := direction.orthogonal()
	var arrow := PackedVector2Array([
		tip,
		shifted[-1] - direction * 6.0 + side * 14.0,
		shifted[-1] + direction * 1.0,
		shifted[-1] - direction * 6.0 - side * 14.0
	])
	draw_colored_polygon(arrow, color)

func _on_settings_changed() -> void:
	elapsed = 0.0
	set_process(not SettingsManager.reduce_motion)
	queue_redraw()
