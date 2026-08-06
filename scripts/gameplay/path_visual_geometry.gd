class_name PathVisualGeometry
extends RefCounted

const PROJECTION_EPSILON := 0.001

static func leading_cell_index(cells: Array[Vector2i], direction: Vector2i) -> int:
	return _select_cell_index(cells, direction, true)

static func trailing_cell_index(cells: Array[Vector2i], direction: Vector2i) -> int:
	return _select_cell_index(cells, direction, false)

static func leading_point(points: PackedVector2Array, direction: Vector2) -> Vector2:
	return _select_point(points, direction, true)

static func trailing_point(points: PackedVector2Array, direction: Vector2) -> Vector2:
	return _select_point(points, direction, false)

static func cell_projection_span(cells: Array[Vector2i], direction: Vector2i) -> int:
	if cells.is_empty() or direction == Vector2i.ZERO:
		return 0
	var minimum_projection: int = _cell_projection(cells[0], direction)
	var maximum_projection: int = minimum_projection
	for cell in cells:
		var projection: int = _cell_projection(cell, direction)
		minimum_projection = mini(minimum_projection, projection)
		maximum_projection = maxi(maximum_projection, projection)
	return maximum_projection - minimum_projection

static func make_triangle(
	base_center: Vector2,
	direction: Vector2,
	length: float,
	half_height: float
) -> PackedVector2Array:
	var points := PackedVector2Array()
	if direction.length_squared() <= 0.0001:
		return points
	var forward: Vector2 = direction.normalized()
	var side: Vector2 = forward.orthogonal()
	points.append(base_center + forward * length)
	points.append(base_center + side * half_height)
	points.append(base_center - side * half_height)
	return points

static func _select_cell_index(
	cells: Array[Vector2i],
	direction: Vector2i,
	leading: bool
) -> int:
	if cells.is_empty() or direction == Vector2i.ZERO:
		return -1
	if cells.size() == 1:
		return 0

	var target_projection: int = _cell_projection(cells[0], direction)
	for cell in cells:
		var projection: int = _cell_projection(cell, direction)
		if leading:
			target_projection = maxi(target_projection, projection)
		else:
			target_projection = mini(target_projection, projection)

	var candidates: Array[int] = []
	for index in range(cells.size()):
		if _cell_projection(cells[index], direction) == target_projection:
			candidates.append(index)

	# Prefer an authored endpoint when it is already on the leading/trailing edge.
	# For projection ties this preserves the previous last=head, first=tail rule.
	var preferred_endpoints: Array[int] = []
	if leading:
		preferred_endpoints.append(cells.size() - 1)
		preferred_endpoints.append(0)
	else:
		preferred_endpoints.append(0)
		preferred_endpoints.append(cells.size() - 1)
	for endpoint_index in preferred_endpoints:
		if endpoint_index in candidates:
			return endpoint_index

	return _closest_cell_to_perpendicular_center(cells, candidates, direction)

static func _closest_cell_to_perpendicular_center(
	cells: Array[Vector2i],
	candidates: Array[int],
	direction: Vector2i
) -> int:
	if candidates.is_empty():
		return -1
	var perpendicular := Vector2(-float(direction.y), float(direction.x))
	var center_projection := 0.0
	for cell in cells:
		center_projection += Vector2(cell).dot(perpendicular)
	center_projection /= float(cells.size())

	var best_index: int = candidates[0]
	var best_distance := INF
	for candidate_index in candidates:
		var candidate_projection: float = Vector2(cells[candidate_index]).dot(perpendicular)
		var distance := absf(candidate_projection - center_projection)
		if distance < best_distance:
			best_distance = distance
			best_index = candidate_index
	return best_index

static func _select_point(
	points: PackedVector2Array,
	direction: Vector2,
	leading: bool
) -> Vector2:
	if points.is_empty() or direction.length_squared() <= 0.0001:
		return Vector2.ZERO
	if points.size() == 1:
		return points[0]

	var forward: Vector2 = direction.normalized()
	var target_projection: float = points[0].dot(forward)
	for point in points:
		var projection: float = point.dot(forward)
		if leading:
			target_projection = maxf(target_projection, projection)
		else:
			target_projection = minf(target_projection, projection)

	var candidates: Array[int] = []
	for index in range(points.size()):
		if absf(points[index].dot(forward) - target_projection) <= PROJECTION_EPSILON:
			candidates.append(index)

	var preferred_endpoints: Array[int] = []
	if leading:
		preferred_endpoints.append(points.size() - 1)
		preferred_endpoints.append(0)
	else:
		preferred_endpoints.append(0)
		preferred_endpoints.append(points.size() - 1)
	for endpoint_index in preferred_endpoints:
		if endpoint_index in candidates:
			return points[endpoint_index]

	var perpendicular: Vector2 = forward.orthogonal()
	var center_projection := 0.0
	for point in points:
		center_projection += point.dot(perpendicular)
	center_projection /= float(points.size())

	var best_index: int = candidates[0]
	var best_distance := INF
	for candidate_index in candidates:
		var distance := absf(points[candidate_index].dot(perpendicular) - center_projection)
		if distance < best_distance:
			best_distance = distance
			best_index = candidate_index
	return points[best_index]

static func _cell_projection(cell: Vector2i, direction: Vector2i) -> int:
	return cell.x * direction.x + cell.y * direction.y
