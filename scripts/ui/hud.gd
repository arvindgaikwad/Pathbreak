extends CanvasLayer

signal restart_pressed
signal hint_pressed
signal back_pressed

@onready var level_label = $TopBar/Margin/VBox/TopRow/HeaderBox/LevelTitle
@onready var difficulty_label = $TopBar/Margin/VBox/TopRow/HeaderBox/DifficultyPill/DiffLabel
@onready var subtitle_label = $TopBar/Margin/VBox/SubtitleLabel
@onready var lives_count_label = $BottomBar/Margin/HBox/LivesCard/VBox/IconBox/CountLabel
@onready var hint_count_badge = $BottomBar/Margin/HBox/HintCard/VBox/IconBox/BadgeLabel
@onready var lives_card = $BottomBar/Margin/HBox/LivesCard
@onready var hint_card = $BottomBar/Margin/HBox/HintCard
@onready var restart_card = $BottomBar/Margin/HBox/RestartCard
@onready var back_button = $TopBar/Margin/VBox/TopRow/BackButton
@onready var settings_button = $TopBar/Margin/VBox/TopRow/SettingsButton

const COLOR_ACCENT = Color("#3B82F6")
const COLOR_PRIMARY_TEXT = Color("#1B2538")
const COLOR_SECONDARY_TEXT = Color("#717D93")

func _ready():
	_apply_styles()
	
	# Wire signals on cards
	lives_card.gui_input.connect(_on_card_input.bind(lives_card, func(): pass))
	hint_card.gui_input.connect(_on_card_input.bind(hint_card, func(): hint_pressed.emit()))
	restart_card.gui_input.connect(_on_card_input.bind(restart_card, func(): restart_pressed.emit()))
	
	back_button.pressed.connect(func():
		AudioManager.play_button_sound()
		back_pressed.emit()
	)

func _apply_styles():
	# Card style box matching Screen 1 of reference image
	var card_style = StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.corner_radius_top_left = 24
	card_style.corner_radius_top_right = 24
	card_style.corner_radius_bottom_left = 24
	card_style.corner_radius_bottom_right = 24
	card_style.shadow_color = Color(0.1, 0.12, 0.18, 0.06)
	card_style.shadow_size = 6
	card_style.shadow_offset = Vector2(0, 4)
	
	for c in [lives_card, hint_card, restart_card]:
		c.add_theme_stylebox_override("panel", card_style)
		c.pivot_offset = Vector2(80, 50)
		
	# Circular top buttons style
	var circle_style = StyleBoxFlat.new()
	circle_style.bg_color = Color.WHITE
	circle_style.corner_radius_top_left = 30
	circle_style.corner_radius_top_right = 30
	circle_style.corner_radius_bottom_left = 30
	circle_style.corner_radius_bottom_right = 30
	circle_style.shadow_color = Color(0.1, 0.12, 0.18, 0.05)
	circle_style.shadow_size = 4
	circle_style.shadow_offset = Vector2(0, 2)
	
	for btn in [back_button, settings_button]:
		btn.add_theme_stylebox_override("normal", circle_style)
		btn.add_theme_stylebox_override("hover", circle_style)
		btn.add_theme_stylebox_override("pressed", circle_style)
		btn.add_theme_stylebox_override("focus", circle_style)

func _on_card_input(event: InputEvent, card: Control, callback: Callable):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or (event is InputEventScreenTouch and event.pressed):
		AudioManager.play_button_sound()
		var t = create_tween()
		t.tween_property(card, "scale", Vector2(0.94, 0.94), 0.08).set_trans(Tween.TRANS_SINE)
		t.tween_property(card, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		callback.call()

func update_hud(level_num: int, diff: String, mistakes: int, hints: int):
	level_label.text = "Level %d" % level_num
	difficulty_label.text = diff
	hint_count_badge.text = str(hints)
	lives_count_label.text = "3"
