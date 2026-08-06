extends CanvasLayer
class_name HowToPlayOverlay

signal closed

const COLOR_PRIMARY := Color("#1B2538")
const COLOR_SECONDARY := Color("#717D93")
const COLOR_ACCENT := Color("#3978F6")
const COLOR_BORDER := Color("#E3E8F0")
const COLOR_CANVAS := Color("#F8F6F0")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 120
	_build_ui()

func _build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color(0.08, 0.10, 0.16, 0.46)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(560.0, 0.0)
	panel.add_theme_stylebox_override("panel", _panel_style())
	center.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 38)
	margin.add_theme_constant_override("margin_top", 34)
	margin.add_theme_constant_override("margin_right", 38)
	margin.add_theme_constant_override("margin_bottom", 34)
	panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 18)
	margin.add_child(content)

	var title := Label.new()
	title.text = "How to Play"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", COLOR_PRIMARY)
	title.add_theme_font_size_override("font_size", 34)
	content.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Find the path with a clear route to the edge."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_color_override("font_color", COLOR_SECONDARY)
	subtitle.add_theme_font_size_override("font_size", 16)
	content.add_child(subtitle)

	content.add_child(_step_card("1", "Read the arrow", "Every path can only leave in the direction of its arrow."))
	content.add_child(_step_card("2", "Check the route", "A path is blocked when another path occupies any cell ahead of it."))
	content.add_child(_step_card("3", "Clear the board", "Remove the free paths in the right order until none remain."))

	var hint := Label.new()
	hint.text = "Hint highlights one path that can leave now."
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_color_override("font_color", COLOR_ACCENT)
	hint.add_theme_font_size_override("font_size", 15)
	content.add_child(hint)

	var close_button := Button.new()
	close_button.custom_minimum_size = Vector2(0.0, 64.0)
	close_button.text = "Got it"
	close_button.add_theme_color_override("font_color", Color.WHITE)
	close_button.add_theme_font_size_override("font_size", 21)
	_apply_button_style(close_button)
	close_button.pressed.connect(func() -> void:
		AudioManager.play_button_sound()
		closed.emit()
		queue_free()
	)
	content.add_child(close_button)

func _step_card(number: String, title_text: String, body_text: String) -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _step_style())

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 14)
	card.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	margin.add_child(row)

	var badge := Label.new()
	badge.custom_minimum_size = Vector2(42.0, 42.0)
	badge.text = number
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge.add_theme_color_override("font_color", Color.WHITE)
	badge.add_theme_font_size_override("font_size", 18)
	badge.add_theme_stylebox_override("normal", _badge_style())
	row.add_child(badge)

	var copy := VBoxContainer.new()
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.add_theme_constant_override("separation", 3)
	row.add_child(copy)

	var heading := Label.new()
	heading.text = title_text
	heading.add_theme_color_override("font_color", COLOR_PRIMARY)
	heading.add_theme_font_size_override("font_size", 18)
	copy.add_child(heading)

	var body := Label.new()
	body.text = body_text
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_color_override("font_color", COLOR_SECONDARY)
	body.add_theme_font_size_override("font_size", 14)
	copy.add_child(body)

	return card

func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color.WHITE
	style.corner_radius_top_left = 32
	style.corner_radius_top_right = 32
	style.corner_radius_bottom_left = 32
	style.corner_radius_bottom_right = 32
	style.shadow_color = Color(0.08, 0.10, 0.16, 0.18)
	style.shadow_size = 18
	style.shadow_offset = Vector2(0.0, 8.0)
	return style

func _step_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_CANVAS
	style.border_color = COLOR_BORDER
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	return style

func _badge_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_ACCENT
	style.corner_radius_top_left = 21
	style.corner_radius_top_right = 21
	style.corner_radius_bottom_left = 21
	style.corner_radius_bottom_right = 21
	return style

func _apply_button_style(button: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = COLOR_ACCENT
	normal.corner_radius_top_left = 20
	normal.corner_radius_top_right = 20
	normal.corner_radius_bottom_left = 20
	normal.corner_radius_bottom_right = 20
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("#2F6AE2")
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", pressed)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("focus", normal)
