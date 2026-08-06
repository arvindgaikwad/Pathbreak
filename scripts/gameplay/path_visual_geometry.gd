class_name PathVisualGeometry
extends RefCounted

enum HeadEndpoint {
	START,
	END
}

const VALID_CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.UP
]

static func direction_from_cells(
	cells: Array[Vector2i],
	head_endpoint: int = HeadEndpoint.END
) -> Vector2i:
	if cells.size() < 2:
		return Vector2i.ZERO
	if head_endpoint == HeadEndpoint.START:
		return cells[0] - cells[1]
	return cells[-1] - cells[-2]

static func direction_from_points(
	points: PackedVector2Array,
	head_endpoint: int = HeadEndpoint.END
) -> Vector2:
	if points.size() < 2:
		return Vector2.ZERO
	var direction: Vector2
	if head_endpoint == HeadEndpoint.START:
		direction = points[0] - points[1]
	else:
		direction = points[-1] - points[-2]
	return direction.normalized()

static func head_cell_index(cells: Array[Vector2i], head_endpoint: int = HeadEndpoint.END) -> int:
	if cells.is_empty():
		return -1
	return 0 if head_endpoint == HeadEndpoint.START else cells.size() - 1

static func neighbour_cell_index(cells: Array[Vector2i], head_endpoint: int = HeadEndpoint.END) -> int:
	if cells.size() < 2:
		return -1
	return 1 if head_endpoint == HeadEndpoint.START else cells.size() - 2

static func tail_cell_index(cells: Array[Vector2i], head_endpoint: int = HeadEndpoint.END) -> int:
	if cells.is_empty():
		return -1
	return cells.size() - 1 if head_endpoint == HeadEndpoint.START else 0

static func head_point(points: PackedVector2Array, head_endpoint: int = HeadEndpoint.END) -> Vector2:
	if points.is_empty():
		return Vector2.ZERO
	return points[0] if head_endpoint == HeadEndpoint.START else points[-1]

static func neighbour_point(points: PackedVector2Array, head_endpoint: int = HeadEndpoint.END) -> Vector2:
	if points.size() < 2:
		return Vector2.ZERO
	return points[1] if head_endpoint == HeadEndpoint.START else points[-2]

static func tail_point(points: PackedVector2Array, head_endpoint: int = HeadEndpoint.END) -> Vector2:
	if points.is_empty():
		return Vector2.ZERO
	return points[-1] if head_endpoint == HeadEndpoint.START else points[0]

static func points_tail_to_head(
	points: PackedVector2Array,
	head_endpoint: int = HeadEndpoint.END
) -> PackedVector2Array:
	var ordered := PackedVector2Array()
	if head_endpoint == HeadEndpoint.START:
		for index in range(points.size() - 1, -1, -1):
			ordered.append(points[index])
	else:
		ordered = points.duplicate()
	return ordered

static func polyline_length(points: PackedVector2Array) -> float:
	var total := 0.0
	for index in range(points.size() - 1):
		total += points[index].distance_to(points[index + 1])
	return total

static func point_at_distance(points: PackedVector2Array, distance: float) -> Vector2:
	if points.is_empty():
		return Vector2.ZERO
	if points.size() == 1:
		return points[0]

	var total_length := polyline_length(points)
	var target := clampf(distance, 0.0, total_length)
	var travelled := 0.0
	for index in range(points.size() - 1):
		var start: Vector2 = points[index]
		var finish: Vector2 = points[index + 1]
		var segment_length := start.distance_to(finish)
		if target <= travelled + segment_length:
			var amount := clampf(
				(target - travelled) / maxf(segment_length, 0.001),
				0.0,
				1.0
			)
			return start.lerp(finish, amount)
		travelled += segment_length
	return points[-1]

static func densify_polyline(
	points: PackedVector2Array,
	maximum_spacing: float
) -> PackedVector2Array:
	var dense := PackedVector2Array()
	if points.is_empty():
		return dense
	dense.append(points[0])
	var safe_spacing := maxf(maximum_spacing, 1.0)
	for index in range(points.size() - 1):
		var start: Vector2 = points[index]
		var finish: Vector2 = points[index + 1]
		var segment_length := start.distance_to(finish)
		if segment_length <= 0.001:
			continue
		var steps := maxi(int(ceil(segment_length / safe_spacing)), 1)
		for step_index in range(1, steps + 1):
			var amount := float(step_index) / float(steps)
			dense.append(start.lerp(finish, amount))
	return dense

static func cumulative_distances(points: PackedVector2Array) -> Array[float]:
	var distances: Array[float] = []
	if points.is_empty():
		return distances
	distances.append(0.0)
	var travelled := 0.0
	for index in range(1, points.size()):
		travelled += points[index - 1].distance_to(points[index])
		distances.append(travelled)
	return distances

static func trim_shaft_for_head(
	points: PackedVector2Array,
	trim_distance: float,
	head_endpoint: int = HeadEndpoint.END
) -> PackedVector2Array:
	var trimmed := points.duplicate()
	if trimmed.size() < 2:
		return trimmed
	var direction := direction_from_points(trimmed, head_endpoint)
	if direction.is_zero_approx():
		return trimmed
	var head_index := 0 if head_endpoint == HeadEndpoint.START else trimmed.size() - 1
	trimmed[head_index] = trimmed[head_index] - direction * maxf(trim_distance, 0.0)
	return trimmed

static func make_triangle_from_tip(
	tip: Vector2,
	direction: Vector2,
	length: float,
	half_height: float
) -> PackedVector2Array:
	var triangle := PackedVector2Array()
	if direction.length_squared() <= 0.0001:
		return triangle
	var forward := direction.normalized()
	var side := forward.orthogonal()
	var base_center := tip - forward * length
	triangle.append(tip)
	triangle.append(base_center + side * half_height)
	triangle.append(base_center - side * half_height)
	return triangle

static func validate_ordered_cells(cells: Array[Vector2i]) -> PackedStringArray:
	var errors := PackedStringArray()
	if cells.size() < 2:
		errors.append("Path requires at least two ordered cells.")
		return errors

	var seen: Dictionary = {}
	for cell_index in range(cells.size()):
		var cell := cells[cell_index]
		if seen.has(cell):
			errors.append("Path contains duplicate cell %s." % cell)
		else:
			seen[cell] = true
		if cell_index == 0:
			continue
		var step := cell - cells[cell_index - 1]
		if step not in VALID_CARDINAL_DIRECTIONS:
			errors.append(
				"Cells %s and %s are not cardinally adjacent." % [
					cells[cell_index - 1],
					cell
				]
			)

	var direction := direction_from_cells(cells)
	if direction not in VALID_CARDINAL_DIRECTIONS:
		errors.append("Final segment does not produce a valid cardinal head direction.")
	return errors

static func legacy_head_endpoint(cells: Array[Vector2i], legacy_direction: Vector2i) -> int:
	if cells.size() < 2:
		return -1
	if legacy_direction == direction_from_cells(cells, HeadEndpoint.END):
		return HeadEndpoint.END
	if legacy_direction == direction_from_cells(cells, HeadEndpoint.START):
		return HeadEndpoint.START
	return -1
