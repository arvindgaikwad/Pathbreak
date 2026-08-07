extends Node2D
class_name PuzzlePiece

const PathVisualGeometryScript = preload("res://scripts/gameplay/path_visual_geometry.gd")

var piece_data: PuzzlePieceData
var piece_id: int
var cells: Array[Vector2i] = []
var exit_direction: Vector2i = Vector2i.ZERO
var head_endpoint: int = PathVisualGeometry.HeadEndpoint.END
var is_removed: bool = false
var is_animating: bool = false
var grid_size: float = 64.0
var direction_marker: Polygon2D = null
var direction_tween: Tween = null

var snake_route := PackedVector2Array()
var snake_body_length: float = 0.0
var snake_exit_distance: float = 0.0
var snake_head_length: float = 0.0
var snake_shaft_trim: float = 0.0
var snake_has_corner: bool = false

@onready var line: Line2D = $Line2D
@onready var arrow_head: Polygon2D = $ArrowHead
@onready var tail_dot: Polygon2D = $TailDot
@onready var area: Area2D = $Area2D

const COLOR_PRIMARY_PATH := Color("#1B2538")
const COLOR_HIGH_CONTRAST_PATH := Color("#07101F")
const COLOR_ACCENT := Color("#3B82F6")
const COLOR_ERROR := Color("#EF5B5B")
const MARKER_START_PROGRESS := 0.0
const MARKER_END_PROGRESS := 1.0
const SNAKE_ESCAPE_DURATION := 0.28
const SNAKE_UNCOIL_PHASE := 0.72

func init_from_data(data: PuzzlePieceData, new_grid_size: float = 64.0) -> void:
	piece_data = data
	piece_id = data.piece_id
	cells = data.cells.duplicate()
	head_endpoint = data.head_endpoint
	exit_direction = PathVisualGeometryScript.direction_from_cells(cells, head_endpoint)
	grid_size = new_grid_size
	if data.exit_direction != Vector2i.ZERO and data.exit_direction != exit_direction:
		push_warning(
			"Piece %d data direction %s differs from ordered path direction %s." % [
				piece_id,
				data.exit_direction,
				exit_direction
			]
		)

func _ready() -> void:
	if area != null:
		area.input_pickable = false
	_update_visuals()
	_create_direction_marker()

func _update_visuals() -> void:
	if cells.size() < 2:
		return

	var source_points := _source_points()
	line.clear_points()
	line.default_color = _normal_color()
	line.width = clampf(grid_size * 0.23, 12.0, 17.0)
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.joint_mode = Line2D.LINE_JOINT_ROUND

	var head_length := clampf(grid_size * 0.38, 22.0, 28.0)
	var shaft_trim := head_length * 0.44
	var render_points := PathVisualGeometryScript.trim_shaft_for_head(
		source_points,
		shaft_trim,
		head_endpoint
	)
	line.points = render_points

	_set_tail_dot_center(PathVisualGeometryScript.tail_point(source_points, head_endpoint))
	_set_arrowhead_geometry(
		PathVisualGeometryScript.head_point(source_points, head_endpoint),
		PathVisualGeometryScript.direction_from_points(source_points, head_endpoint),
		head_length
	)
	_clear_legacy_collisions()

func _source_points() -> PackedVector2Array:
	var source_points := PackedVector2Array()
	for cell in cells:
		source_points.append(_cell_center(cell))
	return source_points

func _cell_center(cell: Vector2i) -> Vector2:
	return Vector2(cell.x * grid_size + grid_size * 0.5, cell.y * grid_size + grid_size * 0.5)

func _direction_vector() -> Vector2:
	return Vector2(exit_direction).normalized()

func _normal_color() -> Color:
	return COLOR_HIGH_CONTRAST_PATH if SettingsManager.high_contrast else COLOR_PRIMARY_PATH

func reset_color() -> void:
	set_color(_normal_color())

func set_color(color: Color) -> void:
	line.default_color = color
	arrow_head.color = color
	tail_dot.color = color

func _set_tail_dot_center(tail_position: Vector2) -> void:
	var points := PackedVector2Array()
	var radius := clampf(grid_size * 0.070, 4.0, 5.5)
	for point_index in range(18):
		var angle := (float(point_index) / 18.0) * TAU
		points.append(tail_position + Vector2(cos(angle), sin(angle)) * radius)
	tail_dot.polygon = points
	tail_dot.color = line.default_color

func _set_arrowhead_geometry(
	head_anchor: Vector2,
	direction: Vector2,
	head_length: float
) -> void:
	var half_height := clampf(grid_size * 0.19, 11.0, 14.0)
	var tip := head_anchor + direction * head_length * 0.56
	arrow_head.polygon = PathVisualGeometryScript.make_triangle_from_tip(
		tip,
		direction,
		head_length,
		half_height
	)
	arrow_head.color = line.default_color

func _create_direction_marker() -> void:
	direction_marker = Polygon2D.new()
	var marker_length := clampf(grid_size * 0.13, 7.0, 9.0)
	var marker_half_height := clampf(grid_size * 0.075, 4.0, 5.5)
	direction_marker.polygon = PathVisualGeometryScript.make_triangle_from_tip(
		Vector2(marker_length, 0.0),
		Vector2.RIGHT,
		marker_length,
		marker_half_height
	)
	direction_marker.rotation = _direction_vector().angle()
	direction_marker.color = COLOR_ACCENT
	direction_marker.visible = false
	add_child(direction_marker)

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
	var source_points := _source_points()
	closest_distance = minf(
		closest_distance,
		local_point.distance_to(PathVisualGeometryScript.head_point(source_points, head_endpoint))
	)
	closest_distance = minf(
		closest_distance,
		local_point.distance_to(PathVisualGeometryScript.tail_point(source_points, head_endpoint))
	)
	return closest_distance

func _distance_to_segment(point: Vector2, start: Vector2, end: Vector2) -> float:
	var segment := end - start
	var length_squared := segment.length_squared()
	if length_squared <= 0.0001:
		return point.distance_to(start)
	var amount := clampf((point - start).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(start + segment * amount)

func _set_direction_marker_progress(progress: float) -> void:
	if direction_marker == null or cells.size() < 2:
		return
	var source_points := _source_points()
	var neighbour := PathVisualGeometryScript.neighbour_point(source_points, head_endpoint)
	var head := PathVisualGeometryScript.head_point(source_points, head_endpoint)
	var direction := PathVisualGeometryScript.direction_from_points(source_points, head_endpoint)
	var start_position := neighbour.lerp(head, 0.32)
	var end_position := head - direction * clampf(grid_size * 0.22, 10.0, 15.0)
	direction_marker.visible = true
	direction_marker.position = start_position.lerp(
		end_position,
		clampf(progress, MARKER_START_PROGRESS, MARKER_END_PROGRESS)
	)

func get_escape_animation_duration() -> float:
	return 0.18 if SettingsManager.reduce_motion else SNAKE_ESCAPE_DURATION

func animate_successful_escape() -> void:
	if is_removed:
		return
	is_removed = true
	is_animating = true
	_stop_pulse()
	set_color(COLOR_ACCENT)

	if SettingsManager.reduce_motion or not _prepare_snake_escape():
		_animate_reduced_motion_escape()
		return

	var tween := create_tween()
	tween.tween_method(
		_set_snake_escape_progress,
		0.0,
		1.0,
		SNAKE_ESCAPE_DURATION
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(queue_free)

func _prepare_snake_escape() -> bool:
	var ordered_points := PathVisualGeometryScript.points_tail_to_head(
		_source_points(),
		head_endpoint
	)
	if ordered_points.size() < 2:
		return false

	snake_body_length = PathVisualGeometryScript.polyline_length(ordered_points)
	if snake_body_length <= 0.001:
		return false

	snake_head_length = clampf(grid_size * 0.38, 22.0, 28.0)
	snake_shaft_trim = snake_head_length * 0.44
	snake_exit_distance = grid_size * 12.0
	snake_has_corner = _path_has_corner(ordered_points)
	snake_route = ordered_points.duplicate()
	snake_route.append(ordered_points[-1] + _direction_vector() * snake_exit_distance)
	_set_snake_escape_progress(0.0)
	return true

func _path_has_corner(points: PackedVector2Array) -> bool:
	if points.size() < 3:
		return false
	for index in range(1, points.size() - 1):
		var incoming := (points[index] - points[index - 1]).normalized()
		var outgoing := (points[index + 1] - points[index]).normalized()
		if not incoming.is_equal_approx(outgoing):
			return true
	return false

func _snake_travel_for_progress(progress: float) -> float:
	var amount := clampf(progress, 0.0, 1.0)
	if not snake_has_corner:
		return (snake_body_length + snake_exit_distance) * amount

	if amount <= SNAKE_UNCOIL_PHASE:
		var uncoil_progress := amount / SNAKE_UNCOIL_PHASE
		return snake_body_length * uncoil_progress

	var exit_progress := (amount - SNAKE_UNCOIL_PHASE) / (1.0 - SNAKE_UNCOIL_PHASE)
	return snake_body_length + snake_exit_distance * exit_progress

func _set_snake_escape_progress(progress: float) -> void:
	if snake_route.size() < 2:
		return

	var travel := _snake_travel_for_progress(progress)
	var moving_points := PathVisualGeometryScript.slice_polyline(
		snake_route,
		travel,
		travel + snake_body_length
	)
	if moving_points.size() < 2:
		return

	var direction := _direction_vector()
	var head_anchor: Vector2 = moving_points[-1]
	var tail_anchor: Vector2 = moving_points[0]
	var render_points := PathVisualGeometryScript.trim_shaft_for_head(
		moving_points,
		snake_shaft_trim,
		PathVisualGeometry.HeadEndpoint.END
	)

	line.points = render_points
	_set_tail_dot_center(tail_anchor)
	_set_arrowhead_geometry(head_anchor, direction, snake_head_length)

func _animate_reduced_motion_escape() -> void:
	var duration := 0.18
	var escape_distance := grid_size * 12.0
	var final_position := position + Vector2(exit_direction) * escape_distance
	var tween := create_tween()
	tween.tween_property(self, "position", final_position, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "modulate:a", 0.0, duration * 0.75)
	tween.tween_callback(queue_free)

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
