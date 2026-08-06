extends CanvasLayer

signal next_pressed
signal replay_pressed

@onready var panel = $Panel
@onready var title_label = $Panel/Margin/VBox/TitleLabel
@onready var sub_label = $Panel/Margin/VBox/SubLabel
@onready var time_val = $Panel/Margin/VBox/StatsContainer/VBox/TimeRow/TimeValue
@onready var moves_val = $Panel/Margin/VBox/StatsContainer/VBox/MovesRow/MovesValue
@onready var hints_val = $Panel/Margin/VBox/StatsContainer/VBox/HintsRow/HintsValue
@onready var stars_label = $Panel/Margin/VBox/StarRating/StarsLabel
@onready var next_button = $Panel/Margin/VBox/HBoxButtons/NextButton
@onready var replay_button = $Panel/Margin/VBox/HBoxButtons/ReplayButton

const COLOR_ACCENT = Color("#2563EB")
const COLOR_PRIMARY_TEXT = Color("#1B2538")
const COLOR_SECONDARY_TEXT = Color("#717D93")

func _ready():
	_apply_styles()
	next_button.pressed.connect(func():
		AudioManager.play_button_sound()
		next_pressed.emit()
	)
	replay_button.pressed.connect(func():
		AudioManager.play_button_sound()
		replay_pressed.emit()
	)

func show_popup(level_num: int, elapsed_sec: float, mistakes: int, hints_used: int = 0):
	title_label.text = "Well done!"
	sub_label.text = "Level %d completed" % level_num
	
	var mins = int(elapsed_sec) / 60
	var secs = int(elapsed_sec) % 60
	time_val.text = "%02d:%02d" % [mins, secs]
	moves_val.text = str(mistakes)
	hints_val.text = str(hints_used)
	
	var stars = 3
	if mistakes > 2:
		stars = 1
	elif mistakes > 0:
		stars = 2
	stars_label.text = "★".repeat(stars) + "☆".repeat(3 - stars)
	
	_animate_in()

func _apply_styles():
	var card_style = StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.corner_radius_top_left = 36
	card_style.corner_radius_top_right = 36
	card_style.corner_radius_bottom_left = 36
	card_style.corner_radius_bottom_right = 36
	card_style.shadow_color = Color(0.1, 0.12, 0.18, 0.12)
	card_style.shadow_size = 16
	card_style.shadow_offset = Vector2(0, 8)
	panel.add_theme_stylebox_override("panel", card_style)
	
	# Replay outline button style
	var replay_style = StyleBoxFlat.new()
	replay_style.bg_color = Color.WHITE
	replay_style.border_color = Color("#2563EB")
	replay_style.border_width_left = 2
	replay_style.border_width_right = 2
	replay_style.border_width_top = 2
	replay_style.border_width_bottom = 2
	replay_style.corner_radius_top_left = 20
	replay_style.corner_radius_top_right = 20
	replay_style.corner_radius_bottom_left = 20
	replay_style.corner_radius_bottom_right = 20
	replay_button.add_theme_stylebox_override("normal", replay_style)
	replay_button.add_theme_stylebox_override("hover", replay_style)
	replay_button.add_theme_stylebox_override("pressed", replay_style)
	replay_button.add_theme_stylebox_override("focus", replay_style)
	
	# Next Level blue filled button style
	var next_style = StyleBoxFlat.new()
	next_style.bg_color = COLOR_ACCENT
	next_style.corner_radius_top_left = 20
	next_style.corner_radius_top_right = 20
	next_style.corner_radius_bottom_left = 20
	next_style.corner_radius_bottom_right = 20
	next_button.add_theme_stylebox_override("normal", next_style)
	next_button.add_theme_stylebox_override("hover", next_style)
	next_button.add_theme_stylebox_override("pressed", next_style)
	next_button.add_theme_stylebox_override("focus", next_style)

func _animate_in():
	$Backdrop.modulate.a = 0
	panel.scale = Vector2(0.8, 0.8)
	panel.modulate.a = 0
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Backdrop, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_property(panel, "scale", Vector2(1.0, 1.0), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
