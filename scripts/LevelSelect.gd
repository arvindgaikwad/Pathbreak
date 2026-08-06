extends Control

const TOTAL_LEVELS = 10

@onready var grid = $UI/ScrollContainer/CenterPadding/LevelGrid
@onready var back_btn = $UI/TopBar/Margin/HBox/BackButton
@onready var progress_card = $UI/ProgressMargin/ProgressCard
@onready var count_label = $UI/ProgressMargin/ProgressCard/Margin/HBox/VBox/CountLabel
@onready var percent_label = $UI/ProgressMargin/ProgressCard/Margin/HBox/PercentLabel

const COLOR_CARD_BG = Color("#FFFFFF")
const COLOR_CARD_LOCKED = Color("#EFF2F7")
const COLOR_PRIMARY_TEXT = Color("#1B2538")
const COLOR_SECONDARY_TEXT = Color("#717D93")
const COLOR_STAR = Color("#F5A623")

func _ready():
	_apply_progress_card_style()
	back_btn.pressed.connect(func():
		AudioManager.play_button_sound()
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	)
	_update_progress()
	_build_grid()

func _apply_progress_card_style():
	var card_style = StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.corner_radius_top_left = 24
	card_style.corner_radius_top_right = 24
	card_style.corner_radius_bottom_left = 24
	card_style.corner_radius_bottom_right = 24
	card_style.shadow_color = Color(0.1, 0.12, 0.18, 0.06)
	card_style.shadow_size = 6
	card_style.shadow_offset = Vector2(0, 4)
	progress_card.add_theme_stylebox_override("panel", card_style)

func _update_progress():
	var unlocked = SaveManager.max_level_unlocked + 1
	var total = TOTAL_LEVELS
	count_label.text = "%d / %d" % [unlocked, total]
	var pct = int((float(unlocked) / total) * 100.0)
	percent_label.text = "%d%%" % pct

func _build_grid():
	var max_unlocked = SaveManager.max_level_unlocked
	for i in range(TOTAL_LEVELS):
		var card = _make_level_card(i, i <= max_unlocked)
		grid.add_child(card)

func _make_level_card(idx: int, unlocked: bool) -> Control:
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(140, 140)
	
	var style = StyleBoxFlat.new()
	style.corner_radius_top_left = 24
	style.corner_radius_top_right = 24
	style.corner_radius_bottom_left = 24
	style.corner_radius_bottom_right = 24
	style.shadow_color = Color(0.1, 0.12, 0.18, 0.06)
	style.shadow_size = 6
	style.shadow_offset = Vector2(0, 4)
	
	if unlocked:
		style.bg_color = COLOR_CARD_BG
		btn.add_theme_color_override("font_color", COLOR_PRIMARY_TEXT)
	else:
		style.bg_color = COLOR_CARD_LOCKED
		btn.add_theme_color_override("font_color", COLOR_SECONDARY_TEXT)
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", style)
	btn.add_theme_stylebox_override("focus", style)
	
	var pressed_style = style.duplicate()
	pressed_style.bg_color = Color(0.95, 0.96, 0.98)
	btn.add_theme_stylebox_override("pressed", pressed_style)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	var num = Label.new()
	num.text = str(idx + 1)
	num.add_theme_font_size_override("font_size", 36)
	num.add_theme_color_override("font_color", COLOR_PRIMARY_TEXT if unlocked else COLOR_SECONDARY_TEXT)
	num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	var stars_label = Label.new()
	var stars = SaveManager.level_stars.get(str(idx), 0)
	if unlocked:
		stars_label.text = "★".repeat(stars) + "☆".repeat(3 - stars)
		stars_label.add_theme_color_override("font_color", COLOR_STAR)
	else:
		stars_label.text = "🔒"
		stars_label.add_theme_color_override("font_color", COLOR_SECONDARY_TEXT)
		
	stars_label.add_theme_font_size_override("font_size", 16)
	stars_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	vbox.add_child(num)
	vbox.add_child(stars_label)
	btn.add_child(vbox)
	
	if unlocked:
		btn.pressed.connect(func():
			AudioManager.play_button_sound()
			SaveManager.current_level = idx
			get_tree().change_scene_to_file("res://scenes/game/game_screen.tscn")
		)
		btn.button_down.connect(func():
			create_tween().tween_property(btn, "scale", Vector2(0.93, 0.93), 0.1).set_trans(Tween.TRANS_SINE)
		)
		btn.button_up.connect(func():
			create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		)
		btn.pivot_offset = btn.custom_minimum_size / 2.0
	
	return btn
