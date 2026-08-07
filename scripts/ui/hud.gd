extends CanvasLayer

signal restart_pressed
signal hint_pressed
signal back_pressed
signal settings_pressed

@onready var level_label: Label = $TopBar/Margin/VBox/TopRow/HeaderBox/LevelTitle
@onready var difficulty_label: Label = $TopBar/Margin/VBox/TopRow/HeaderBox/DifficultyPill/DiffLabel
@onready var subtitle_label: Label = $TopBar/Margin/VBox/SubtitleLabel
@onready var lives_count_label: Label = $BottomBar/Margin/HBox/LivesCard/VBox/IconBox/CountLabel
@onready var hint_count_badge: Label = $BottomBar/Margin/HBox/HintCard/VBox/IconBox/BadgeLabel
@onready var hint_title_label: Label = $BottomBar/Margin/HBox/HintCard/VBox/TitleLabel
@onready var lives_card: PanelContainer = $BottomBar/Margin/HBox/LivesCard
@onready var hint_card: PanelContainer = $BottomBar/Margin/HBox/HintCard
@onready var restart_card: PanelContainer = $BottomBar/Margin/HBox/RestartCard
@onready var hint_button: Button = $BottomBar/Margin/HBox/HintCard/ClickTarget
@onready var restart_button: Button = $BottomBar/Margin/HBox/RestartCard/ClickTarget
@onready var back_button: Button = $TopBar/Margin/VBox/TopRow/BackButton
@onready var settings_button: Button = $TopBar/Margin/VBox/TopRow/SettingsButton

const COLOR_ACCENT := Color("#3B82F6")
const COLOR_PRIMARY_TEXT := Color("#1B2538")
const COLOR_SECONDARY_TEXT := Color("#717D93")
const COLOR_BORDER := Color("#E7EBF1")
const DEFAULT_SUBTITLE := "Clear all paths"

var interaction_locked: bool = false
var controls_enabled: bool = true
var message_tween: Tween = null

func _ready() -> void:
	_apply_styles()
	lives_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hint_button.pressed.connect(
		_on_action_card_pressed.bind(hint_card, func() -> void: hint_pressed.emit())
	)
	restart_button.pressed.connect(
		_on_action_card_pressed.bind(restart_card, func() -> void: restart_pressed.emit())
	)
	back_button.pressed.connect(func() -> void:
		if not controls_enabled:
			return
		AudioManager.play_button_sound()
		back_pressed.emit()
	)
	settings_button.pressed.connect(func() -> void:
		if not controls_enabled:
			return
		AudioManager.play_button_sound()
		settings_pressed.emit()
	)

func _apply_styles() -> void:
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.border_color = COLOR_BORDER
	card_style.border_width_left = 1
	card_style.border_width_top = 1
	card_style.border_width_right = 1
	card_style.border_width_bottom = 1
	card_style.corner_radius_top_left = 22
	card_style.corner_radius_top_right = 22
	card_style.corner_radius_bottom_left = 22
	card_style.corner_radius_bottom_right = 22
	card_style.shadow_color = Color(0.1, 0.12, 0.18, 0.055)
	card_style.shadow_size = 5
	card_style.shadow_offset = Vector2(0, 3)

	for card in [lives_card, hint_card, restart_card]:
		card.add_theme_stylebox_override("panel", card_style)
		card.pivot_offset = card.custom_minimum_size * 0.5

	var circle_style := StyleBoxFlat.new()
	circle_style.bg_color = Color.WHITE
	circle_style.border_color = COLOR_BORDER
	circle_style.border_width_left = 1
	circle_style.border_width_top = 1
	circle_style.border_width_right = 1
	circle_style.border_width_bottom = 1
	circle_style.corner_radius_top_left = 26
	circle_style.corner_radius_top_right = 26
	circle_style.corner_radius_bottom_left = 26
	circle_style.corner_radius_bottom_right = 26
	circle_style.shadow_color = Color(0.1, 0.12, 0.18, 0.045)
	circle_style.shadow_size = 3
	circle_style.shadow_offset = Vector2(0, 2)

	var circle_pressed := circle_style.duplicate() as StyleBoxFlat
	circle_pressed.bg_color = Color("#F0F3F7")
	for button in [back_button, settings_button]:
		button.add_theme_stylebox_override("normal", circle_style)
		button.add_theme_stylebox_override("hover", circle_pressed)
		button.add_theme_stylebox_override("pressed", circle_pressed)
		button.add_theme_stylebox_override("focus", circle_style)

func _on_action_card_pressed(card: Control, callback: Callable) -> void:
	if interaction_locked or not controls_enabled:
		return

	interaction_locked = true
	AudioManager.play_button_sound()
	var tween := create_tween()
	tween.tween_property(card, "scale", Vector2(0.96, 0.96), 0.07).set_trans(Tween.TRANS_SINE)
	tween.tween_property(card, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func() -> void: interaction_locked = false)
	callback.call()

func update_hud(level_num: int, difficulty: String, lives: int, hints: int) -> void:
	level_label.text = "Level %d" % level_num
	difficulty_label.text = difficulty
	lives_count_label.text = str(maxi(lives, 0))

	var tutorial_hint_available := level_num == 1 and not SaveManager.tutorial_completed
	if tutorial_hint_available:
		hint_count_badge.text = "FREE"
		hint_title_label.text = "Hint"
	elif hints > 0:
		hint_count_badge.text = "×%d" % hints
		hint_title_label.text = "Hint"
	else:
		hint_count_badge.text = "+3"
		hint_title_label.text = "Refill"

	# The card remains active at zero because it opens the refill flow.
	hint_card.modulate = Color.WHITE

func show_message(message: String, accent: bool = false) -> void:
	if message_tween != null and message_tween.is_valid():
		message_tween.kill()
	subtitle_label.text = message
	subtitle_label.add_theme_color_override(
		"font_color",
		COLOR_ACCENT if accent else COLOR_SECONDARY_TEXT
	)
	message_tween = create_tween()
	message_tween.tween_interval(1.8)
	message_tween.tween_callback(func() -> void:
		subtitle_label.text = DEFAULT_SUBTITLE
		subtitle_label.add_theme_color_override("font_color", COLOR_SECONDARY_TEXT)
	)

func set_controls_enabled(enabled: bool) -> void:
	controls_enabled = enabled
	back_button.disabled = not enabled
	settings_button.disabled = not enabled
	hint_button.disabled = not enabled
	restart_button.disabled = not enabled
	var alpha := 1.0 if enabled else 0.55
	back_button.modulate.a = alpha
	settings_button.modulate.a = alpha
	hint_card.modulate.a = alpha
	restart_card.modulate.a = alpha
