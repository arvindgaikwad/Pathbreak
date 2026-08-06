extends CanvasLayer
class_name SettingsOverlay

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
	panel.custom_minimum_size = Vector2(540.0, 0.0)
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
	title.text = "Settings"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", COLOR_PRIMARY)
	title.add_theme_font_size_override("font_size", 34)
	content.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Make Pathbreak comfortable for you."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_color_override("font_color", COLOR_SECONDARY)
	subtitle.add_theme_font_size_override("font_size", 16)
	content.add_child(subtitle)

	content.add_child(_setting_row("Sound effects", "Puzzle and interface feedback", SettingsManager.sound_enabled, func(enabled: bool) -> void: SettingsManager.set_sound_enabled(enabled)))
	content.add_child(_setting_row("Haptics", "Touch vibration on supported devices", SettingsManager.haptics_enabled, func(enabled: bool) -> void: SettingsManager.set_haptics_enabled(enabled)))
	content.add_child(_setting_row("Reduce motion", "Stops the menu demonstration and shortens effects", SettingsManager.reduce_motion, func(enabled: bool) -> void: SettingsManager.set_reduce_motion(enabled)))
	content.add_child(_setting_row("High contrast", "Stronger path and board separation", SettingsManager.high_contrast, func(enabled: bool) -> void: SettingsManager.set_high_contrast(enabled)))

	var close_button := Button.new()
	close_button.custom_minimum_size = Vector2(0.0, 64.0)
	close_button.text = "Done"
	close_button.add_theme_color_override("font_color", Color.WHITE)
	close_button.add_theme_font_size_override("font_size", 21)
	_apply_button_style(close_button)
	close_button.pressed.connect(func() -> void:
		AudioManager.play_button_sound()
		closed.emit()
		queue_free()
	)
	content.add_child(close_button)

func _setting_row(
	title_text: String,
	description_text: String,
	initial_value: bool,
	callback: Callable
) -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", _row_style())

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_bottom", 12)
	card.add_child(margin)

	var row := HBoxContainer.new()
	row.custom_minimum_size = Vector2(0.0, 60.0)
	row.add_theme_constant_override("separation", 16)
	margin.add_child(row)

	var copy := VBoxContainer.new()
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.add_theme_constant_override("separation", 2)
	row.add_child(copy)

	var heading := Label.new()
	heading.text = title_text
	heading.add_theme_color_override("font_color", COLOR_PRIMARY)
	heading.add_theme_font_size_override("font_size", 18)
	copy.add_child(heading)

	var body := Label.new()
	body.text = description_text
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_color_override("font_color", COLOR_SECONDARY)
	body.add_theme_font_size_override("font_size", 13)
	copy.add_child(body)

	var toggle := CheckButton.new()
	toggle.custom_minimum_size = Vector2(84.0, 52.0)
	toggle.text = "ON" if initial_value else "OFF"
	toggle.set_pressed_no_signal(initial_value)
	toggle.add_theme_color_override("font_color", COLOR_PRIMARY)
	toggle.add_theme_font_size_override("font_size", 13)
	toggle.toggled.connect(func(enabled: bool) -> void:
		toggle.text = "ON" if enabled else "OFF"
		callback.call(enabled)
	)
	row.add_child(toggle)

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

func _row_style() -> StyleBoxFlat:
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
