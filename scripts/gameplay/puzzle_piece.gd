extends Node2D
class_name PuzzlePiece

signal piece_tapped(piece: PuzzlePiece)

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

const COLOR_PRIMARY_PATH = Color("#1B2538")
const COLOR_ACCENT = Color("#3B82F6")
const COLOR_ERROR = Color("#EF5B5B")

func init_from_data(data: PuzzlePieceData, g_size: float = 64.0):
	piece_data = data
	piece_id = data.piece_id
	cells = data.cells.duplicate()
	exit_direction = data.exit_direction
	grid_size = g_size

func _ready():
	_update_visuals()
	if area:
		area.input_event.connect(_on_area_input_event)

func _update_visuals():
	if cells.is_empty():
		return
		
	if line:
		line.clear_points()
		line.default_color = COLOR_PRIMARY_PATH
		line.width = 16.0
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		line.joint_mode = Line2D.LINE_JOINT_ROUND
		for cell in cells:
			var pos = Vector2(cell.x * grid_size + grid_size/2.0, cell.y * grid_size + grid_size/2.0)
			line.add_point(pos)
			
	_draw_tail_dot()
	_draw_arrowhead()
	_create_collisions()

func set_color(c: Color):
	if line:
		line.default_color = c
	if arrow_head:
		arrow_head.color = c
	if tail_dot:
		tail_dot.color = c

func _draw_tail_dot():
	if cells.is_empty() or not tail_dot:
		return
	var tail_pos = Vector2(cells[0].x * grid_size + grid_size/2.0, cells[0].y * grid_size + grid_size/2.0)
	var num_pts = 16
	var pts = PackedVector2Array()
	var radius = 10.0
	for i in range(num_pts):
		var angle = (float(i) / num_pts) * TAU
		pts.append(tail_pos + Vector2(cos(angle), sin(angle)) * radius)
	tail_dot.polygon = pts
	tail_dot.color = COLOR_PRIMARY_PATH

func _draw_arrowhead():
	if cells.is_empty() or not arrow_head:
		return
		
	var head_pos = Vector2(cells[-1].x * grid_size + grid_size/2.0, cells[-1].y * grid_size + grid_size/2.0)
	var angle = Vector2(exit_direction).angle()
	var points = PackedVector2Array()
	
	var p1 = Vector2(24, 0).rotated(angle) + head_pos
	var p2 = Vector2(-4, -18).rotated(angle) + head_pos
	var p3 = Vector2(4, 0).rotated(angle) + head_pos
	var p4 = Vector2(-4, 18).rotated(angle) + head_pos
	
	points.append(p1)
	points.append(p2)
	points.append(p3)
	points.append(p4)
	
	arrow_head.polygon = points
	arrow_head.color = COLOR_PRIMARY_PATH

func _create_collisions():
	if not area:
		return
	for child in area.get_children():
		child.queue_free()
		
	if cells.size() < 1:
		return
		
	for i in range(cells.size() - 1):
		var p1 = Vector2(cells[i].x * grid_size + grid_size/2.0, cells[i].y * grid_size + grid_size/2.0)
		var p2 = Vector2(cells[i+1].x * grid_size + grid_size/2.0, cells[i+1].y * grid_size + grid_size/2.0)
		
		var rect_shape = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		var length = p1.distance_to(p2)
		rect.size = Vector2(length + 36, 36)
		rect_shape.shape = rect
		rect_shape.position = (p1 + p2) / 2.0
		rect_shape.rotation = (p2 - p1).angle()
		area.add_child(rect_shape)
		
	if cells.size() == 1:
		var p1 = Vector2(cells[0].x * grid_size + grid_size/2.0, cells[0].y * grid_size + grid_size/2.0)
		var rect_shape = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = Vector2(44, 44)
		rect_shape.shape = rect
		rect_shape.position = p1
		area.add_child(rect_shape)

func _on_area_input_event(_viewport, event, _shape_idx):
	if is_removed or is_animating:
		return
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or (event is InputEventScreenTouch and event.pressed):
		piece_tapped.emit(self)

func animate_successful_escape():
	if is_removed:
		return
	is_removed = true
	is_animating = true
	set_color(COLOR_ACCENT)
	_spawn_escape_trail()
	
	var tween = create_tween()
	var escape_distance = grid_size * 12.0
	var final_pos = position + Vector2(exit_direction) * escape_distance
	tween.tween_property(self, "position", final_pos, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.25)
	tween.tween_callback(queue_free)

func _spawn_escape_trail():
	if cells.is_empty() or not get_parent():
		return
	var trail = Line2D.new()
	trail.width = 10.0
	trail.default_color = Color(COLOR_ACCENT.r, COLOR_ACCENT.g, COLOR_ACCENT.b, 0.4)
	trail.begin_cap_mode = Line2D.LINE_CAP_ROUND
	trail.end_cap_mode = Line2D.LINE_CAP_ROUND
	for cell in cells:
		var pos = Vector2(cell.x * grid_size + grid_size/2.0, cell.y * grid_size + grid_size/2.0)
		trail.add_point(pos)
	get_parent().add_child(trail)
	trail.position = position
	
	var t = create_tween()
	t.tween_property(trail, "modulate:a", 0.0, 0.3)
	t.tween_callback(trail.queue_free)

func animate_blocked_tap():
	if is_removed or is_animating:
		return
	is_animating = true
	set_color(COLOR_ERROR)
	
	var tween = create_tween()
	var shake_dir = Vector2(exit_direction) * 10.0
	tween.tween_property(self, "position", shake_dir, 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", -shake_dir, 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2.ZERO, 0.05).set_trans(Tween.TRANS_SINE)
	
	get_tree().create_timer(0.25).timeout.connect(func():
		is_animating = false
		if not is_removed:
			set_color(COLOR_PRIMARY_PATH)
	)

func set_idle_pulse(escapable: bool):
	if has_meta("idle_tween"):
		var existing = get_meta("idle_tween")
		if existing:
			existing.kill()
		remove_meta("idle_tween")
		
	if escapable and not is_removed:
		var tween = create_tween().set_loops()
		tween.tween_property(self, "scale", Vector2(1.04, 1.04), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		set_meta("idle_tween", tween)
	else:
		scale = Vector2.ONE
