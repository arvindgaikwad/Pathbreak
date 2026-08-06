extends Control
class_name LivingBoard

const COLOR_CARD := Color("#FFFFFF")
const COLOR_BORDER := Color("#E4E9F0")
const COLOR_SHADOW := Color(0.08, 0.10, 0.16, 0.08)
const COLOR_GRID := Color("#DDE3EC")
const COLOR_PATH := Color("#1B2538")
const COLOR_ACCENT := Color("#3978F6")

const CYCLE_DURATION := 4.4
const PULSE_START := 0.45
const PULSE_DURATION := 1.20
const HIGHLIGHT_DURATION := 0.42
const ESCAPE_START := PULSE_START + PULSE_DURATION + HIGHLIGHT_DURATION
const ESCAPE_DURATION := 0.72
const MARKER_START_PROGRESS := 0.06
const MARKER_END_PROGRESS := 0.78

var elapsed: float = 0.0
var active_index: int = 0

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

	var paths: Array[PackedVector2Array] = _get_paths()
	var directions: Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	for index in range(paths.size()):
		var offset := Vector2.ZERO
		var path_color := COLOR_PATH
		var marker_progress: float = -1.0

		if index == active_index:
			if SettingsManager.reduce_motion:
				path_color = COLOR_ACCENT
			elif elapsed >= ESCAPE_START:
				path_color = COLOR_ACCENT
				var escape_progress := clampf(
					(elapsed - ESCAPE_START) / ESCAPE_DURATION,
					0.0,
					1.0
				)
				offset = directions[index] * ease(escape_progress, 1.6) * 150.0
			elif elapsed >= PULSE_START + PULSE_DURATION:
				path_color = COLOR_ACCENT
			elif elapsed >= PULSE_START:
				var normalized_progress := clampf(
					(elapsed - PULSE_START) / PULSE_DURATION,
					0.0,
					1.0
				)
				marker_progress = lerpf(
					MARKER_START_PROGRESS,
					MARKER_END_PROGRESS,
					normalized_progress
				)

		var shifted: PackedVector2Array = _shift_points(paths[index], offset)
		_draw_path(shifted, directions[index], path_color)
		if marker_progress >= 0.0:
			_draw_direction_marker(shifted, marker_progress)

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

func _shift_points(points: PackedVector2Array, offset: Vector2) -> PackedVector2Array:
	var shifted := PackedVector2Array()
	for point in points:
		shifted.append(point + offset)
	return shifted

func _draw_path(points: PackedVector2Array, direction: Vector2, color: Color) -> void:
	if points.is_empty():
		return

	draw_polyline(points, color, 13.0, true)
	draw_circle(points[0], 4.8, color)

	var length := 28.0
	var half_height := 15.0
	var base_offset := 6.0
	var tip := points[-1] + direction * length
	var side := direction.orthogonal()
	var arrow := PackedVector2Array([
		tip,
		points[-1] - direction * base_offset + side * half_height,
		points[-1] - direction * base_offset - side * half_height
	])
	draw_colored_polygon(arrow, color)

func _draw_direction_marker(points: PackedVector2Array, progress: float) -> void:
	var total_length := _polyline_length(points)
	if total_length <= 0.0:
		return
	var marker_distance := total_length * clampf(
		progress,
		MARKER_START_PROGRESS,
		MARKER_END_PROGRESS
	)
	draw_circle(_point_at_distance(points, marker_distance), 5.5, COLOR_ACCENT)

func _polyline_length(points: PackedVector2Array) -> float:
	var total := 0.0
	for index in range(points.size() - 1):
		total += points[index].distance_to(points[index + 1])
	return total

func _point_at_distance(points: PackedVector2Array, target_distance: float) -> Vector2:
	if points.is_empty():
		return Vector2.ZERO
	if points.size() == 1:
		return points[0]

	var traveled := 0.0
	for index in range(points.size() - 1):
		var start: Vector2 = points[index]
		var finish: Vector2 = points[index + 1]
		var segment_length := start.distance_to(finish)
		if target_distance <= traveled + segment_length:
			var amount := clampf(
				(target_distance - traveled) / maxf(segment_length, 0.001),
				0.0,
				1.0
			)
			return start.lerp(finish, amount)
		traveled += segment_length
	return points[-1]

func _on_settings_changed() -> void:
	elapsed = 0.0
	set_process(not SettingsManager.reduce_motion)
	queue_redraw()
