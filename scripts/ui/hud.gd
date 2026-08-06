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
@onready var lives_card: PanelContainer = $BottomBar/Margin/HBox/LivesCard
@onready var hint_card: PanelContainer = $BottomBar/Margin/HBox/HintCard
@onready var restart_card: PanelContainer = $BottomBar/Margin/HBox/RestartCard
@onready var back_button: Button = $TopBar/Margin/VBox/TopRow/BackButton
@onready var settings_button: Button = $TopBar/Margin/VBox/TopRow/SettingsButton

const COLOR_ACCENT := Color("#3B82F6")
const COLOR_PRIMARY_TEXT := Color("#1B2538")
const COLOR_SECONDARY_TEXT := Color("#717D93")
const DEFAULT_SUBTITLE := "Clear all paths"

var interaction_locked := false
var controls_enabled := true
var message_tween: Tween = null

func _ready() -> void:
	_apply_styles()
	lives_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hint_count_badge.add_theme_color_override("font_color", COLOR_ACCENT)
	hint_count_badge.add_theme_font_size_override("font_size", 14)
	hint_card.gui_input.connect(_on_card_input.bind(hint_card, func() -> void: hint_pressed.emit()))
	restart_card.gui_input.connect(_on_card_input.bind(restart_card, func() -> void: restart_pressed.emit()))
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
	card_style.corner_radius_top_left = 24
	card_style.corner_radius_top_right = 24
	card_style.corner_radius_bottom_left = 24
	card_style.corner_radius_bottom_right = 24
	card_style.shadow_color = Color(0.1, 0.12, 0.18, 0.06)
	card_style.shadow_size = 6
	card_style.shadow_offset = Vector2(0, 4)

	for card in [lives_card, hint_card, restart_card]:
		card.add_theme_stylebox_override("panel", card_style)
		card.pivot_offset = Vector2(80, 50)

	var circle_style := StyleBoxFlat.new()
	circle_style.bg_color = Color.WHITE
	circle_style.corner_radius_top_left = 30
	circle_style.corner_radius_top_right = 30
	circle_style.corner_radius_bottom_left = 30
	circle_style.corner_radius_bottom_right = 30
	circle_style.shadow_color = Color(0.1, 0.12, 0.18, 0.05)
	circle_style.shadow_size = 4
	circle_style.shadow_offset = Vector2(0, 2)

	for button in [back_button, settings_button]:
		button.add_theme_stylebox_override("normal", circle_style)
		button.add_theme_stylebox_override("hover", circle_style)
		button.add_theme_stylebox_override("pressed", circle_style)
		button.add_theme_stylebox_override("focus", circle_style)

func _on_card_input(event: InputEvent, card: Control, callback: Callable) -> void:
	if interaction_locked or not controls_enabled:
		return
	var activated: bool = (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	) or (event is InputEventScreenTouch and event.pressed)
	if not activated:
		return

	interaction_locked = true
	AudioManager.play_button_sound()
	var tween := create_tween()
	tween.tween_property(card, "scale", Vector2(0.94, 0.94), 0.08).set_trans(Tween.TRANS_SINE)
	tween.tween_property(card, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func() -> void: interaction_locked = false)
	callback.call()

func update_hud(level_num: int, difficulty: String, lives: int, hints: int) -> void:
	level_label.text = "Level %d" % level_num
	difficulty_label.text = difficulty
	hint_count_badge.text = "×%d" % maxi(hints, 0)
	hint_count_badge.visible = true
	lives_count_label.text = str(maxi(lives, 0))
	hint_card.modulate = Color.WHITE if hints > 0 else Color(1.0, 1.0, 1.0, 0.58)

func show_message(message: String, accent: bool = false) -> void:
	if message_tween != null and message_tween.is_valid():
		message_tween.kill()
	subtitle_label.text = message
	subtitle_label.add_theme_color_override(
		"font_color",
		COLOR_ACCENT if accent else COLOR_SECONDARY_TEXT
	)
	message_tween = create_tween()
	message_tween.tween_interval(1.6)
	message_tween.tween_callback(func() -> void:
		subtitle_label.text = DEFAULT_SUBTITLE
		subtitle_label.add_theme_color_override("font_color", COLOR_SECONDARY_TEXT)
	)

func set_controls_enabled(enabled: bool) -> void:
	controls_enabled = enabled
	back_button.disabled = not enabled
	settings_button.disabled = not enabled
	hint_card.mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE
	restart_card.mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE
