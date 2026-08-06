extends CanvasLayer

signal next_pressed
signal replay_pressed

@onready var panel: PanelContainer = $Panel
@onready var star_badge: PanelContainer = $StarBadge
@onready var title_label: Label = $Panel/Margin/VBox/TitleLabel
@onready var sub_label: Label = $Panel/Margin/VBox/SubLabel
@onready var rating_label: Label = $Panel/Margin/VBox/RatingLabel
@onready var stats_container: PanelContainer = $Panel/Margin/VBox/StatsContainer
@onready var time_value: Label = $Panel/Margin/VBox/StatsContainer/StatsMargin/VBox/TimeRow/TimeValue
@onready var moves_value: Label = $Panel/Margin/VBox/StatsContainer/StatsMargin/VBox/MovesRow/MovesValue
@onready var mistakes_value: Label = $Panel/Margin/VBox/StatsContainer/StatsMargin/VBox/MistakesRow/MistakesValue
@onready var hints_value: Label = $Panel/Margin/VBox/StatsContainer/StatsMargin/VBox/HintsRow/HintsValue
@onready var stars_label: Label = $Panel/Margin/VBox/StarRating/StarsLabel
@onready var next_button: Button = $Panel/Margin/VBox/HBoxButtons/NextButton
@onready var replay_button: Button = $Panel/Margin/VBox/HBoxButtons/ReplayButton

const COLOR_ACCENT := Color("#2563EB")
const COLOR_ACCENT_DARK := Color("#1E55CC")
const COLOR_BORDER := Color("#DDE3EC")
const COLOR_STATS_BG := Color("#F6F8FB")
const COLOR_STAR := Color("#F5A623")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_apply_styles()
	next_button.pressed.connect(func() -> void:
		AudioManager.play_button_sound()
		next_pressed.emit()
	)
	replay_button.pressed.connect(func() -> void:
		AudioManager.play_button_sound()
		replay_pressed.emit()
	)

func show_popup(
	level_number: int,
	elapsed_seconds: float,
	moves: int,
	mistakes: int,
	hints_used: int = 0
) -> void:
	title_label.text = "Well done!"
	sub_label.text = "Level %d completed" % level_number

	var total_seconds := maxi(int(elapsed_seconds), 0)
	var minutes := int(floor(float(total_seconds) / 60.0))
	var seconds := total_seconds % 60
	time_value.text = "%02d:%02d" % [minutes, seconds]
	moves_value.text = str(maxi(moves, 0))
	mistakes_value.text = str(maxi(mistakes, 0))
	hints_value.text = str(maxi(hints_used, 0))

	var stars := 3
	if mistakes > 2:
		stars = 1
	elif mistakes > 0:
		stars = 2
	stars_label.text = "★".repeat(stars) + "☆".repeat(3 - stars)

	if stars == 3 and hints_used == 0:
		rating_label.text = "Perfect clear"
	elif stars >= 2:
		rating_label.text = "Clean clear"
	else:
		rating_label.text = "Level cleared"

	_animate_in()

func _apply_styles() -> void:
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.corner_radius_top_left = 32
	card_style.corner_radius_top_right = 32
	card_style.corner_radius_bottom_left = 32
	card_style.corner_radius_bottom_right = 32
	card_style.shadow_color = Color(0.08, 0.10, 0.16, 0.16)
	card_style.shadow_size = 16
	card_style.shadow_offset = Vector2(0, 8)
	panel.add_theme_stylebox_override("panel", card_style)

	var badge_style := StyleBoxFlat.new()
	badge_style.bg_color = Color("#FFF8E8")
	badge_style.border_color = Color("#FFE4A8")
	badge_style.border_width_left = 2
	badge_style.border_width_top = 2
	badge_style.border_width_right = 2
	badge_style.border_width_bottom = 2
	badge_style.corner_radius_top_left = 35
	badge_style.corner_radius_top_right = 35
	badge_style.corner_radius_bottom_left = 35
	badge_style.corner_radius_bottom_right = 35
	badge_style.shadow_color = Color(0.16, 0.13, 0.05, 0.10)
	badge_style.shadow_size = 8
	badge_style.shadow_offset = Vector2(0, 4)
	star_badge.add_theme_stylebox_override("panel", badge_style)

	var stats_style := StyleBoxFlat.new()
	stats_style.bg_color = COLOR_STATS_BG
	stats_style.border_color = Color("#E8ECF2")
	stats_style.border_width_left = 1
	stats_style.border_width_top = 1
	stats_style.border_width_right = 1
	stats_style.border_width_bottom = 1
	stats_style.corner_radius_top_left = 18
	stats_style.corner_radius_top_right = 18
	stats_style.corner_radius_bottom_left = 18
	stats_style.corner_radius_bottom_right = 18
	stats_container.add_theme_stylebox_override("panel", stats_style)

	var replay_style := StyleBoxFlat.new()
	replay_style.bg_color = Color.WHITE
	replay_style.border_color = COLOR_ACCENT
	replay_style.border_width_left = 2
	replay_style.border_width_right = 2
	replay_style.border_width_top = 2
	replay_style.border_width_bottom = 2
	replay_style.corner_radius_top_left = 18
	replay_style.corner_radius_top_right = 18
	replay_style.corner_radius_bottom_left = 18
	replay_style.corner_radius_bottom_right = 18

	var replay_pressed := replay_style.duplicate() as StyleBoxFlat
	replay_pressed.bg_color = Color("#EDF3FF")
	replay_button.add_theme_stylebox_override("normal", replay_style)
	replay_button.add_theme_stylebox_override("hover", replay_pressed)
	replay_button.add_theme_stylebox_override("pressed", replay_pressed)
	replay_button.add_theme_stylebox_override("focus", replay_style)

	var next_style := StyleBoxFlat.new()
	next_style.bg_color = COLOR_ACCENT
	next_style.corner_radius_top_left = 18
	next_style.corner_radius_top_right = 18
	next_style.corner_radius_bottom_left = 18
	next_style.corner_radius_bottom_right = 18

	var next_pressed := next_style.duplicate() as StyleBoxFlat
	next_pressed.bg_color = COLOR_ACCENT_DARK
	next_button.add_theme_stylebox_override("normal", next_style)
	next_button.add_theme_stylebox_override("hover", next_pressed)
	next_button.add_theme_stylebox_override("pressed", next_pressed)
	next_button.add_theme_stylebox_override("focus", next_style)

	stars_label.add_theme_color_override("font_color", COLOR_STAR)

func _animate_in() -> void:
	if SettingsManager.reduce_motion:
		return
	$Backdrop.modulate.a = 0.0
	panel.scale = Vector2(0.9, 0.9)
	panel.modulate.a = 0.0
	star_badge.scale = Vector2(0.7, 0.7)
	star_badge.modulate.a = 0.0
	star_badge.pivot_offset = star_badge.size * 0.5

	var tween := create_tween().set_parallel(true)
	tween.tween_property($Backdrop, "modulate:a", 1.0, 0.20).set_trans(Tween.TRANS_SINE)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.32).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.22).set_trans(Tween.TRANS_SINE)
	tween.tween_property(star_badge, "scale", Vector2.ONE, 0.36).set_delay(0.08).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(star_badge, "modulate:a", 1.0, 0.20).set_delay(0.08)
