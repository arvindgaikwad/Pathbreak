extends CanvasLayer

signal resume_pressed
signal restart_pressed
signal menu_pressed

var panel: PanelContainer
var backdrop: ColorRect
var sound_toggle: CheckButton
var music_toggle: CheckButton
var haptics_toggle: CheckButton
var reduce_motion_toggle: CheckButton
var high_contrast_toggle: CheckButton

const COLOR_CANVAS := Color("#F8F6F0")
const COLOR_CARD := Color("#FFFFFF")
const COLOR_PRIMARY := Color("#1B2538")
const COLOR_SECONDARY := Color("#717D93")
const COLOR_ACCENT := Color("#3978F6")
const COLOR_DIVIDER := Color("#E6EAF0")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	_build_ui()
	_sync_from_settings()
	_animate_in()

func _build_ui() -> void:
	backdrop = ColorRect.new()
	backdrop.color = Color(0.10, 0.13, 0.20, 0.44)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(560.0, 0.0)
	panel.add_theme_stylebox_override("panel", _make_panel_style())
	center.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_top", 36)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_bottom", 36)
	panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 18)
	margin.add_child(content)

	var title := Label.new()
	title.text = "Paused"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", COLOR_PRIMARY)
	title.add_theme_font_size_override("font_size", 36)
	content.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Adjust the experience or continue the level."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_color_override("font_color", COLOR_SECONDARY)
	subtitle.add_theme_font_size_override("font_size", 17)
	content.add_child(subtitle)

	content.add_child(_make_divider())

	sound_toggle = _add_setting_row(content, "Sound effects", "Puzzle and interface feedback")
	music_toggle = _add_setting_row(content, "Music", "Background music when added")
	haptics_toggle = _add_setting_row(content, "Haptics", "Touch vibration for success and errors")
	reduce_motion_toggle = _add_setting_row(content, "Reduce motion", "Shorter transitions and no idle pulsing")
	high_contrast_toggle = _add_setting_row(content, "High contrast", "Stronger path and board separation")

	content.add_child(_make_divider())

	var resume_button := Button.new()
	resume_button.custom_minimum_size = Vector2(0.0, 68.0)
	resume_button.text = "Resume"
	resume_button.add_theme_color_override("font_color", Color.WHITE)
	resume_button.add_theme_font_size_override("font_size", 22)
	_apply_button_style(resume_button, true)
	resume_button.pressed.connect(func() -> void:
		AudioManager.play_button_sound()
		resume_pressed.emit()
	)
	content.add_child(resume_button)

	var secondary_buttons := HBoxContainer.new()
	secondary_buttons.add_theme_constant_override("separation", 14)
	content.add_child(secondary_buttons)

	var restart_button := Button.new()
	restart_button.custom_minimum_size = Vector2(0.0, 58.0)
	restart_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	restart_button.text = "Restart"
	restart_button.add_theme_color_override("font_color", COLOR_PRIMARY)
	restart_button.add_theme_font_size_override("font_size", 19)
	_apply_button_style(restart_button, false)
	restart_button.pressed.connect(func() -> void:
		AudioManager.play_button_sound()
		restart_pressed.emit()
	)
	secondary_buttons.add_child(restart_button)

	var menu_button := Button.new()
	menu_button.custom_minimum_size = Vector2(0.0, 58.0)
	menu_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu_button.text = "Main Menu"
	menu_button.add_theme_color_override("font_color", COLOR_PRIMARY)
	menu_button.add_theme_font_size_override("font_size", 19)
	_apply_button_style(menu_button, false)
	menu_button.pressed.connect(func() -> void:
		AudioManager.play_button_sound()
		menu_pressed.emit()
	)
	secondary_buttons.add_child(menu_button)

	sound_toggle.toggled.connect(SettingsManager.set_sound_enabled)
	music_toggle.toggled.connect(SettingsManager.set_music_enabled)
	haptics_toggle.toggled.connect(SettingsManager.set_haptics_enabled)
	reduce_motion_toggle.toggled.connect(SettingsManager.set_reduce_motion)
	high_contrast_toggle.toggled.connect(SettingsManager.set_high_contrast)
	resume_button.grab_focus()

func _add_setting_row(parent: VBoxContainer, title_text: String, description_text: String) -> CheckButton:
	var row := HBoxContainer.new()
	row.custom_minimum_size = Vector2(0.0, 58.0)
	row.add_theme_constant_override("separation", 16)
	parent.add_child(row)

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_theme_constant_override("separation", 2)
	row.add_child(text_box)

	var title := Label.new()
	title.text = title_text
	title.add_theme_color_override("font_color", COLOR_PRIMARY)
	title.add_theme_font_size_override("font_size", 18)
	text_box.add_child(title)

	var description := Label.new()
	description.text = description_text
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.add_theme_color_override("font_color", COLOR_SECONDARY)
	description.add_theme_font_size_override("font_size", 13)
	text_box.add_child(description)

	var toggle := CheckButton.new()
	toggle.custom_minimum_size = Vector2(72.0, 52.0)
	toggle.focus_mode = Control.FOCUS_ALL
	row.add_child(toggle)
	return toggle

func _make_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_CARD
	style.corner_radius_top_left = 34
	style.corner_radius_top_right = 34
	style.corner_radius_bottom_left = 34
	style.corner_radius_bottom_right = 34
	style.shadow_color = Color(0.08, 0.10, 0.16, 0.18)
	style.shadow_size = 18
	style.shadow_offset = Vector2(0.0, 8.0)
	return style

func _make_divider() -> ColorRect:
	var divider := ColorRect.new()
	divider.custom_minimum_size = Vector2(0.0, 1.0)
	divider.color = COLOR_DIVIDER
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return divider

func _apply_button_style(button: Button, primary: bool) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = COLOR_ACCENT if primary else COLOR_CANVAS
	normal.border_color = COLOR_ACCENT if primary else COLOR_DIVIDER
	normal.border_width_left = 0 if primary else 2
	normal.border_width_top = 0 if primary else 2
	normal.border_width_right = 0 if primary else 2
	normal.border_width_bottom = 0 if primary else 2
	normal.corner_radius_top_left = 20
	normal.corner_radius_top_right = 20
	normal.corner_radius_bottom_left = 20
	normal.corner_radius_bottom_right = 20

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("#2F6AE2") if primary else Color("#EEF1F5")
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", normal)
	button.add_theme_stylebox_override("focus", normal)
	button.add_theme_stylebox_override("pressed", pressed)

func _sync_from_settings() -> void:
	sound_toggle.set_pressed_no_signal(SettingsManager.sound_enabled)
	music_toggle.set_pressed_no_signal(SettingsManager.music_enabled)
	haptics_toggle.set_pressed_no_signal(SettingsManager.haptics_enabled)
	reduce_motion_toggle.set_pressed_no_signal(SettingsManager.reduce_motion)
	high_contrast_toggle.set_pressed_no_signal(SettingsManager.high_contrast)

func _animate_in() -> void:
	if SettingsManager.reduce_motion:
		return
	backdrop.modulate.a = 0.0
	panel.modulate.a = 0.0
	panel.scale = Vector2(0.92, 0.92)
	panel.pivot_offset = panel.size * 0.5
	var tween := create_tween().set_parallel(true)
	tween.tween_property(backdrop, "modulate:a", 1.0, 0.18)
	tween.tween_property(panel, "modulate:a", 1.0, 0.22)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
