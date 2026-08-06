extends Node2D
class_name PuzzlePiece

var piece_data: PuzzlePieceData
var piece_id: int
var cells: Array[Vector2i] = []
var exit_direction: Vector2i
var is_removed: bool = false
var is_animating: bool = false
var grid_size: float = 64.0
var direction_marker: Polygon2D = null
var direction_tween: Tween = null

@onready var line: Line2D = $Line2D
@onready var arrow_head: Polygon2D = $ArrowHead
@onready var tail_dot: Polygon2D = $TailDot
@onready var area: Area2D = $Area2D

const COLOR_PRIMARY_PATH := Color("#1B2538")
const COLOR_HIGH_CONTRAST_PATH := Color("#07101F")
const COLOR_ACCENT := Color("#3B82F6")
const COLOR_ERROR := Color("#EF5B5B")
const MARKER_START_PROGRESS := 0.06
const MARKER_END_PROGRESS := 0.78

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
	_create_direction_marker()

func _update_visuals() -> void:
	if cells.is_empty():
		return

	line.clear_points()
	line.default_color = _normal_color()
	line.width = clampf(grid_size * 0.23, 12.0, 17.0)
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
	var radius := clampf(grid_size * 0.075, 4.5, 6.0)
	for point_index in range(18):
		var angle := (float(point_index) / 18.0) * TAU
		points.append(tail_position + Vector2(cos(angle), sin(angle)) * radius)
	tail_dot.polygon = points
	tail_dot.color = _normal_color()

func _draw_arrowhead() -> void:
	var head_position := _cell_center(cells[-1])
	var angle := Vector2(exit_direction).angle()
	var length := clampf(grid_size * 0.42, 24.0, 30.0)
	var half_height := clampf(grid_size * 0.22, 13.0, 16.0)
	var base_offset := clampf(grid_size * 0.10, 5.0, 7.0)

	# A simple filled triangle stays readable in every cardinal direction and
	# avoids the forked/fish-tail silhouette created by the previous notch.
	arrow_head.polygon = PackedVector2Array([
		Vector2(length, 0.0).rotated(angle) + head_position,
		Vector2(-base_offset, -half_height).rotated(angle) + head_position,
		Vector2(-base_offset, half_height).rotated(angle) + head_position
	])
	arrow_head.color = _normal_color()

func _create_direction_marker() -> void:
	direction_marker = Polygon2D.new()
	direction_marker.polygon = _circle_polygon(clampf(grid_size * 0.075, 4.5, 6.0))
	direction_marker.color = COLOR_ACCENT
	direction_marker.visible = false
	add_child(direction_marker)

func _circle_polygon(radius: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for point_index in range(20):
		var angle := (float(point_index) / 20.0) * TAU
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	return points

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

func _set_direction_marker_progress(progress: float) -> void:
	if direction_marker == null or line.points.is_empty():
		return
	direction_marker.visible = true
	direction_marker.position = _point_on_path(clampf(progress, MARKER_START_PROGRESS, MARKER_END_PROGRESS))

func _point_on_path(progress: float) -> Vector2:
	if line.points.is_empty():
		return Vector2.ZERO
	if line.points.size() == 1:
		return line.points[0]

	var total_length := 0.0
	for index in range(line.points.size() - 1):
		total_length += line.points[index].distance_to(line.points[index + 1])

	var target_distance := total_length * progress
	var traveled := 0.0
	for index in range(line.points.size() - 1):
		var start: Vector2 = line.points[index]
		var finish: Vector2 = line.points[index + 1]
		var segment_length := start.distance_to(finish)
		if target_distance <= traveled + segment_length:
			var amount := clampf(
				(target_distance - traveled) / maxf(segment_length, 0.001),
				0.0,
				1.0
			)
			return start.lerp(finish, amount)
		traveled += segment_length
	return line.points[-1]

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
	reset_color()
	if SettingsManager.reduce_motion:
		set_color(COLOR_ACCENT)
		var color_timer := get_tree().create_timer(0.55)
		color_timer.timeout.connect(reset_color)
		return

	direction_tween = create_tween()
	direction_tween.tween_method(
		_set_direction_marker_progress,
		MARKER_START_PROGRESS,
		MARKER_END_PROGRESS,
		0.62
	).set_trans(Tween.TRANS_SINE)
	direction_tween.tween_callback(func() -> void:
		_hide_direction_marker()
		set_color(COLOR_ACCENT)
	)
	direction_tween.tween_interval(0.62)
	direction_tween.tween_callback(reset_color)

func play_final_clear_preview() -> void:
	if is_removed:
		return
	_stop_pulse()
	reset_color()
	if SettingsManager.reduce_motion:
		set_color(COLOR_ACCENT)
		return
	direction_tween = create_tween()
	direction_tween.tween_method(
		_set_direction_marker_progress,
		MARKER_START_PROGRESS,
		MARKER_END_PROGRESS,
		0.38
	).set_trans(Tween.TRANS_SINE)
	direction_tween.tween_callback(func() -> void:
		_hide_direction_marker()
		set_color(COLOR_ACCENT)
	)

func set_idle_pulse(enabled: bool) -> void:
	_stop_pulse()
	if not enabled or is_removed:
		if not is_removed:
			reset_color()
		return
	if SettingsManager.reduce_motion:
		set_color(COLOR_ACCENT)
		return

	reset_color()
	direction_tween = create_tween().set_loops()
	direction_tween.tween_method(
		_set_direction_marker_progress,
		MARKER_START_PROGRESS,
		MARKER_END_PROGRESS,
		0.82
	).set_trans(Tween.TRANS_SINE)
	direction_tween.tween_callback(_hide_direction_marker)
	direction_tween.tween_interval(0.48)

func _hide_direction_marker() -> void:
	if direction_marker != null:
		direction_marker.visible = false

func _stop_pulse() -> void:
	if direction_tween != null and direction_tween.is_valid():
		direction_tween.kill()
	direction_tween = null
	_hide_direction_marker()
	scale = Vector2.ONE
