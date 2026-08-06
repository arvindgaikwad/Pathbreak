extends Node2D
class_name PuzzlePiece

var piece_data: PuzzlePieceData
var piece_id: int
var cells: Array[Vector2i] = []
var exit_direction: Vector2i
var is_removed: bool = false
var is_animating: bool = false
var grid_size: float = 64.0

@onready var line: Line2D = $Line2D
@onready var arrow_head: Polygon2D = $ArrowHead
@onready var tail_dot: Polygon2D = $TailDot
@onready var area: Area2D = $Area2D

const COLOR_PRIMARY_PATH := Color("#1B2538")
const COLOR_HIGH_CONTRAST_PATH := Color("#07101F")
const COLOR_ACCENT := Color("#3B82F6")
const COLOR_ERROR := Color("#EF5B5B")

func init_from_data(data: PuzzlePieceData, new_grid_size: float = 64.0) -> void:
	piece_data = data
	piece_id = data.piece_id
	cells = data.cells.duplicate()
	exit_direction = data.exit_direction
	grid_size = new_grid_size

func _ready() -> void:
	if area != null:
		area.input_pickable = false
	_update_visuals()

func _update_visuals() -> void:
	if cells.is_empty():
		return

	line.clear_points()
	line.default_color = _normal_color()
	line.width = clampf(grid_size * 0.25, 12.0, 18.0)
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	for cell in cells:
		line.add_point(_cell_center(cell))

	_draw_tail_dot()
	_draw_arrowhead()
	_clear_legacy_collisions()

func _cell_center(cell: Vector2i) -> Vector2:
	return Vector2(cell.x * grid_size + grid_size * 0.5, cell.y * grid_size + grid_size * 0.5)

func _normal_color() -> Color:
	return COLOR_HIGH_CONTRAST_PATH if SettingsManager.high_contrast else COLOR_PRIMARY_PATH

func reset_color() -> void:
	set_color(_normal_color())

func set_color(color: Color) -> void:
	line.default_color = color
	arrow_head.color = color
	tail_dot.color = color

func _draw_tail_dot() -> void:
	var tail_position := _cell_center(cells[0])
	var points := PackedVector2Array()
	var radius := clampf(grid_size * 0.16, 8.0, 11.0)
	for point_index in range(18):
		var angle := (float(point_index) / 18.0) * TAU
		points.append(tail_position + Vector2(cos(angle), sin(angle)) * radius)
	tail_dot.polygon = points
	tail_dot.color = _normal_color()

func _draw_arrowhead() -> void:
	var head_position := _cell_center(cells[-1])
	var angle := Vector2(exit_direction).angle()
	var length := clampf(grid_size * 0.38, 19.0, 26.0)
	var half_height := clampf(grid_size * 0.28, 14.0, 19.0)
	var notch := clampf(grid_size * 0.07, 3.0, 5.0)
	arrow_head.polygon = PackedVector2Array([
		Vector2(length, 0.0).rotated(angle) + head_position,
		Vector2(-notch, -half_height).rotated(angle) + head_position,
		Vector2(notch, 0.0).rotated(angle) + head_position,
		Vector2(-notch, half_height).rotated(angle) + head_position
	])
	arrow_head.color = _normal_color()

func _clear_legacy_collisions() -> void:
	if area == null:
		return
	for child in area.get_children():
		child.queue_free()

func distance_to_path(local_point: Vector2) -> float:
	if line.points.is_empty():
		return INF
	if line.points.size() == 1:
		return local_point.distance_to(line.points[0])

	var closest_distance := INF
	for point_index in range(line.points.size() - 1):
		closest_distance = minf(
			closest_distance,
			_distance_to_segment(local_point, line.points[point_index], line.points[point_index + 1])
		)
	closest_distance = minf(closest_distance, local_point.distance_to(line.points[0]))
	closest_distance = minf(closest_distance, local_point.distance_to(line.points[-1]))
	return closest_distance

func _distance_to_segment(point: Vector2, start: Vector2, end: Vector2) -> float:
	var segment := end - start
	var length_squared := segment.length_squared()
	if length_squared <= 0.0001:
		return point.distance_to(start)
	var amount := clampf((point - start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(start + segment * amount)

func animate_successful_escape() -> void:
	if is_removed:
		return
	is_removed = true
	is_animating = true
	_stop_pulse()
	set_color(COLOR_ACCENT)
	if not SettingsManager.reduce_motion:
		_spawn_escape_trail()

	var duration := 0.18 if SettingsManager.reduce_motion else 0.35
	var escape_distance := grid_size * 12.0
	var final_position := position + Vector2(exit_direction) * escape_distance
	var tween := create_tween()
	tween.tween_property(self, "position", final_position, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "modulate:a", 0.0, duration * 0.75)
	tween.tween_callback(queue_free)

func _spawn_escape_trail() -> void:
	if cells.is_empty() or get_parent() == null:
		return
	var trail := Line2D.new()
	trail.width = maxf(line.width - 5.0, 6.0)
	trail.default_color = Color(COLOR_ACCENT.r, COLOR_ACCENT.g, COLOR_ACCENT.b, 0.35)
	trail.begin_cap_mode = Line2D.LINE_CAP_ROUND
	trail.end_cap_mode = Line2D.LINE_CAP_ROUND
	for cell in cells:
		trail.add_point(_cell_center(cell))
	get_parent().add_child(trail)
	trail.position = position

	var tween := create_tween()
	tween.tween_property(trail, "modulate:a", 0.0, 0.28)
	tween.tween_callback(trail.queue_free)

func animate_blocked_tap() -> void:
	if is_removed or is_animating:
		return
	is_animating = true
	_stop_pulse()
	set_color(COLOR_ERROR)

	var distance := 5.0 if SettingsManager.reduce_motion else 10.0
	var shake_direction := Vector2(exit_direction) * distance
	var tween := create_tween()
	tween.tween_property(self, "position", shake_direction, 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", -shake_direction, 0.09).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2.ZERO, 0.05).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(func() -> void:
		is_animating = false
		if not is_removed:
			reset_color()
	)

func play_hint_pulse() -> void:
	if is_removed:
		return
	_stop_pulse()
	set_color(COLOR_ACCENT)
	if SettingsManager.reduce_motion:
		var color_timer := get_tree().create_timer(0.35)
		color_timer.timeout.connect(reset_color)
		return

	var tween := create_tween().set_loops(3)
	tween.tween_property(self, "scale", Vector2(1.10, 1.10), 0.16).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(func() -> void:
		reset_color()
		scale = Vector2.ONE
	)

func set_idle_pulse(enabled: bool) -> void:
	_stop_pulse()
	if not enabled or is_removed or SettingsManager.reduce_motion:
		scale = Vector2.ONE
		return
	var tween := create_tween().set_loops()
	tween.tween_property(self, "scale", Vector2(1.035, 1.035), 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	set_meta("idle_tween", tween)

func _stop_pulse() -> void:
	if has_meta("idle_tween"):
		var existing = get_meta("idle_tween")
		if existing is Tween:
			existing.kill()
		remove_meta("idle_tween")
	scale = Vector2.ONE
