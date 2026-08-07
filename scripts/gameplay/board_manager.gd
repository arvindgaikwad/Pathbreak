extends Node2D

signal piece_selected(piece: PuzzlePiece)

var PuzzlePieceScene: PackedScene = preload("res://scenes/game/puzzle_piece.tscn")

var board_size := Vector2i(8, 8)
var grid_size := 64.0
var occupancy: Dictionary = {}
var pieces: Array[PuzzlePiece] = []
var input_enabled := true
var assist_pulses_enabled: bool = false
var completion_tween: Tween = null

@onready var pieces_container: Node2D = $PiecesContainer

const VISUAL_PADDING := 28.0
const COLOR_BOARD_CARD := Color("#FFFFFF")
const COLOR_SHADOW := Color(0.1, 0.12, 0.18, 0.06)
const COLOR_GRID_DOTS := Color("#DDE3EC")
const COLOR_GRID_DOTS_HIGH := Color("#B8C1CF")

func _ready() -> void:
	SettingsManager.settings_changed.connect(_on_settings_changed)

func _draw() -> void:
	var board_width := board_size.x * grid_size
	var board_height := board_size.y * grid_size
	var offset_x := -board_width * 0.5
	var offset_y := -board_height * 0.5
	var card_rect := Rect2(
		Vector2(offset_x - VISUAL_PADDING, offset_y - VISUAL_PADDING),
		Vector2(board_width + VISUAL_PADDING * 2.0, board_height + VISUAL_PADDING * 2.0)
	)

	var shadow_rect := card_rect
	shadow_rect.position += Vector2(0.0, 6.0)
	_draw_rounded_stylebox(shadow_rect, COLOR_SHADOW, 32)
	_draw_rounded_stylebox(card_rect, COLOR_BOARD_CARD, 32)

	var dot_color := COLOR_GRID_DOTS_HIGH if SettingsManager.high_contrast else COLOR_GRID_DOTS
	for x in range(board_size.x + 1):
		for y in range(board_size.y + 1):
			var point := Vector2(offset_x + x * grid_size, offset_y + y * grid_size)
			draw_circle(point, 3.5, dot_color)

func _draw_rounded_stylebox(rect: Rect2, color: Color, radius: int) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	draw_style_box(style, rect)

func setup_level(level_data: PuzzleLevelData) -> void:
	clear_board()
	board_size = level_data.board_size
	queue_redraw()

	var board_width := board_size.x * grid_size
	var board_height := board_size.y * grid_size
	pieces_container.position = Vector2(-board_width * 0.5, -board_height * 0.5)

	for piece_data in level_data.pieces:
		var piece := PuzzlePieceScene.instantiate() as PuzzlePiece
		piece.init_from_data(piece_data, grid_size)
		pieces_container.add_child(piece)
		pieces.append(piece)
		for cell in piece.cells:
			occupancy[cell] = piece.piece_id

func clear_board() -> void:
	assist_pulses_enabled = false
	occupancy.clear()
	pieces.clear()
	if completion_tween != null and completion_tween.is_valid():
		completion_tween.kill()
	completion_tween = null
	scale = Vector2.ONE
	if pieces_container == null:
		return
	for child in pieces_container.get_children():
		child.queue_free()

func remove_piece_occupancy(piece: PuzzlePiece) -> void:
	for cell in piece.cells:
		occupancy.erase(cell)

func can_piece_escape(piece: PuzzlePiece) -> bool:
	return MovementValidator.can_escape_piece(
		piece.piece_id,
		piece.cells,
		piece.exit_direction,
		board_size,
		occupancy
	)

func get_escapable_piece_ids() -> PackedInt32Array:
	var ids := PackedInt32Array()
	for piece in pieces:
		if not is_instance_valid(piece) or piece.is_removed:
			continue
		if can_piece_escape(piece):
			ids.append(piece.piece_id)
	return ids

func get_newly_escapable_pieces(previous_ids: PackedInt32Array) -> Array[PuzzlePiece]:
	var previous_set: Dictionary = {}
	for piece_id in previous_ids:
		previous_set[piece_id] = true

	var newly_escapable: Array[PuzzlePiece] = []
	for piece in pieces:
		if not is_instance_valid(piece) or piece.is_removed or piece.is_animating:
			continue
		if previous_set.has(piece.piece_id):
			continue
		if can_piece_escape(piece):
			newly_escapable.append(piece)
	return newly_escapable

func play_newly_freed_feedback(candidates: Array[PuzzlePiece]) -> int:
	var signalled := 0
	for piece in candidates:
		if not is_instance_valid(piece) or piece.is_removed or piece.is_animating:
			continue
		if not can_piece_escape(piece):
			continue
		piece.play_newly_freed_feedback()
		signalled += 1
	return signalled

func play_completion_settle() -> void:
	if SettingsManager.reduce_motion:
		return
	if completion_tween != null and completion_tween.is_valid():
		completion_tween.kill()
	completion_tween = create_tween()
	completion_tween.tween_property(self, "scale", Vector2.ONE * 0.992, 0.055).set_trans(Tween.TRANS_SINE)
	completion_tween.tween_property(self, "scale", Vector2.ONE * 1.006, 0.09).set_trans(Tween.TRANS_SINE)
	completion_tween.tween_property(self, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_SINE)
	completion_tween.finished.connect(func() -> void:
		completion_tween = null
		scale = Vector2.ONE
	)

func get_first_escapable_piece() -> PuzzlePiece:
	for piece in pieces:
		if is_instance_valid(piece) and not piece.is_removed and can_piece_escape(piece):
			return piece
	return null

func get_only_remaining_piece() -> PuzzlePiece:
	var candidate: PuzzlePiece = null
	for piece in pieces:
		if not is_instance_valid(piece) or piece.is_removed:
			continue
		if candidate != null:
			return null
		candidate = piece
	return candidate

func update_assist_pulses(enabled: bool) -> void:
	assist_pulses_enabled = enabled
	for piece in pieces:
		if is_instance_valid(piece) and not piece.is_removed:
			piece.set_idle_pulse(enabled and can_piece_escape(piece))

func get_visual_size() -> Vector2:
	return Vector2(
		board_size.x * grid_size + VISUAL_PADDING * 2.0,
		board_size.y * grid_size + VISUAL_PADDING * 2.0
	)

func set_input_enabled(enabled: bool) -> void:
	input_enabled = enabled

func _unhandled_input(event: InputEvent) -> void:
	if not input_enabled:
		return

	var pressed := false
	var screen_position := Vector2.ZERO
	if event is InputEventScreenTouch:
		pressed = event.pressed
		screen_position = event.position
	elif event is InputEventMouseButton:
		pressed = event.pressed and event.button_index == MOUSE_BUTTON_LEFT
		screen_position = event.position
	else:
		return

	if not pressed:
		return

	var closest_piece: PuzzlePiece = null
	var closest_distance := INF
	for piece in pieces:
		if not is_instance_valid(piece) or piece.is_removed or piece.is_animating:
			continue
		var canvas_to_piece := piece.get_global_transform_with_canvas().affine_inverse()
		var local_position := canvas_to_piece * screen_position
		var distance := piece.distance_to_path(local_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_piece = piece

	var canvas_scale := absf(get_global_transform_with_canvas().get_scale().x)
	var local_threshold := 40.0 / maxf(canvas_scale, 0.1)
	if closest_piece != null and closest_distance <= local_threshold:
		piece_selected.emit(closest_piece)
		get_viewport().set_input_as_handled()

func _on_settings_changed() -> void:
	queue_redraw()
	for piece in pieces:
		if not is_instance_valid(piece) or piece.is_removed or piece.is_animating:
			continue
		piece.set_idle_pulse(assist_pulses_enabled and can_piece_escape(piece))
