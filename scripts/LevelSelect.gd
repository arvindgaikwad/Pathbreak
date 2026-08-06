extends Control

const TOTAL_LEVELS := 10
const COLOR_CARD_BG := Color("#FFFFFF")
const COLOR_CARD_LOCKED := Color("#EEF1F5")
const COLOR_PRIMARY_TEXT := Color("#1B2538")
const COLOR_SECONDARY_TEXT := Color("#717D93")
const COLOR_ACCENT := Color("#3978F6")
const COLOR_ACCENT_SOFT := Color("#EAF2FF")
const COLOR_BORDER := Color("#DDE3EC")
const COLOR_STAR := Color("#F5A623")

@onready var grid: GridContainer = $UI/ScrollContainer/CenterPadding/LevelGrid
@onready var back_btn: Button = $UI/TopBar/Margin/HBox/BackButton
@onready var progress_card: PanelContainer = $UI/ProgressMargin/ProgressCard
@onready var count_label: Label = $UI/ProgressMargin/ProgressCard/Margin/HBox/VBox/CountLabel
@onready var percent_label: Label = $UI/ProgressMargin/ProgressCard/Margin/HBox/PercentLabel

func _ready() -> void:
	_apply_progress_card_style()
	_apply_back_button_style()
	back_btn.pressed.connect(_on_back_pressed)
	_update_progress()
	_configure_grid_columns()
	_build_grid()

func _apply_progress_card_style() -> void:
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.border_color = Color("#EDF0F4")
	card_style.border_width_left = 1
	card_style.border_width_top = 1
	card_style.border_width_right = 1
	card_style.border_width_bottom = 1
	card_style.corner_radius_top_left = 24
	card_style.corner_radius_top_right = 24
	card_style.corner_radius_bottom_left = 24
	card_style.corner_radius_bottom_right = 24
	card_style.shadow_color = Color(0.1, 0.12, 0.18, 0.06)
	card_style.shadow_size = 6
	card_style.shadow_offset = Vector2(0, 4)
	progress_card.add_theme_stylebox_override("panel", card_style)

func _apply_back_button_style() -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color.WHITE
	normal.corner_radius_top_left = 28
	normal.corner_radius_top_right = 28
	normal.corner_radius_bottom_left = 28
	normal.corner_radius_bottom_right = 28
	normal.shadow_color = Color(0.1, 0.12, 0.18, 0.05)
	normal.shadow_size = 4
	normal.shadow_offset = Vector2(0, 2)

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("#F0F3F7")
	back_btn.add_theme_stylebox_override("normal", normal)
	back_btn.add_theme_stylebox_override("hover", pressed)
	back_btn.add_theme_stylebox_override("pressed", pressed)
	back_btn.add_theme_stylebox_override("focus", normal)

func _on_back_pressed() -> void:
	AudioManager.play_button_sound()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _update_progress() -> void:
	var completed := 0
	for stars in SaveManager.level_stars.values():
		if int(stars) > 0:
			completed += 1
	var unlocked := mini(SaveManager.max_level_unlocked + 1, TOTAL_LEVELS)
	count_label.text = "%d cleared  ·  %d unlocked" % [completed, unlocked]
	var percentage := int(round((float(completed) / float(TOTAL_LEVELS)) * 100.0))
	percent_label.text = "%d%%" % percentage

func _configure_grid_columns() -> void:
	var viewport_width := get_viewport_rect().size.x
	grid.columns = 5 if viewport_width >= 760.0 else 4

func _build_grid() -> void:
	for child in grid.get_children():
		child.queue_free()

	var max_unlocked := SaveManager.max_level_unlocked
	for level_index in range(TOTAL_LEVELS):
		grid.add_child(_make_level_card(level_index, level_index <= max_unlocked))

func _make_level_card(level_index: int, unlocked: bool) -> Control:
	var viewport_width := get_viewport_rect().size.x
	var card_size := 132.0 if viewport_width >= 760.0 else 112.0
	var button := Button.new()
	button.custom_minimum_size = Vector2(card_size, card_size)
	button.clip_contents = true

	var stars := int(SaveManager.level_stars.get(str(level_index), 0))
	var is_next := unlocked and stars <= 0 and level_index == SaveManager.current_level
	var normal_style := _make_level_card_style(unlocked, is_next)
	var pressed_style := normal_style.duplicate() as StyleBoxFlat
	pressed_style.bg_color = Color("#E7EFFB") if unlocked else COLOR_CARD_LOCKED
	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", pressed_style if unlocked else normal_style)
	button.add_theme_stylebox_override("pressed", pressed_style)
	button.add_theme_stylebox_override("focus", normal_style)
	button.disabled = not unlocked
	button.focus_mode = Control.FOCUS_ALL if unlocked else Control.FOCUS_NONE

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	button.add_child(margin)

	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 8)
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(content)

	var number_label := Label.new()
	number_label.text = str(level_index + 1)
	number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	number_label.add_theme_font_size_override("font_size", 32 if viewport_width >= 760.0 else 28)
	number_label.add_theme_color_override(
		"font_color",
		COLOR_ACCENT if is_next else (COLOR_PRIMARY_TEXT if unlocked else COLOR_SECONDARY_TEXT)
	)
	content.add_child(number_label)

	var status_label := Label.new()
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_font_size_override("font_size", 12)
	if not unlocked:
		status_label.text = "LOCKED"
		status_label.add_theme_color_override("font_color", Color("#9AA4B4"))
	elif stars > 0:
		status_label.text = "★".repeat(stars) + "☆".repeat(3 - stars)
		status_label.add_theme_color_override("font_color", COLOR_STAR)
	elif is_next:
		status_label.text = "NEXT"
		status_label.add_theme_color_override("font_color", COLOR_ACCENT)
	else:
		status_label.text = "PLAY"
		status_label.add_theme_color_override("font_color", COLOR_SECONDARY_TEXT)
	content.add_child(status_label)

	if unlocked:
		button.pressed.connect(func() -> void:
			AudioManager.play_button_sound()
			SaveManager.current_level = level_index
			SaveManager.save_game()
			get_tree().change_scene_to_file("res://scenes/game/game_screen.tscn")
		)
		button.button_down.connect(func() -> void:
			create_tween().tween_property(button, "scale", Vector2(0.95, 0.95), 0.08).set_trans(Tween.TRANS_SINE)
		)
		button.button_up.connect(func() -> void:
			create_tween().tween_property(button, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		)
		button.pivot_offset = button.custom_minimum_size * 0.5

	return button

func _make_level_card_style(unlocked: bool, is_next: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_ACCENT_SOFT if is_next else (COLOR_CARD_BG if unlocked else COLOR_CARD_LOCKED)
	style.border_color = COLOR_ACCENT if is_next else (COLOR_BORDER if unlocked else Color("#E3E7ED"))
	style.border_width_left = 2 if is_next else 1
	style.border_width_top = 2 if is_next else 1
	style.border_width_right = 2 if is_next else 1
	style.border_width_bottom = 2 if is_next else 1
	style.corner_radius_top_left = 22
	style.corner_radius_top_right = 22
	style.corner_radius_bottom_left = 22
	style.corner_radius_bottom_right = 22
	style.shadow_color = Color(0.1, 0.12, 0.18, 0.05 if unlocked else 0.025)
	style.shadow_size = 5
	style.shadow_offset = Vector2(0, 3)
	return style
