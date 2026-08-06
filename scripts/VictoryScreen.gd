extends CanvasLayer

signal next_pressed
signal replay_pressed
signal levels_pressed

@onready var panel = $Panel
@onready var level_label = $Panel/Margin/VBox/LevelLabel
@onready var stars_label = $Panel/Margin/VBox/StarContainer/StarsLabel
@onready var time_label = $Panel/Margin/VBox/StatsBox/TimeLabel
@onready var mistakes_label = $Panel/Margin/VBox/StatsBox/MistakesLabel
@onready var next_button = $Panel/Margin/VBox/NextButton
@onready var replay_button = $Panel/Margin/VBox/HBox/ReplayButton
@onready var levels_button = $Panel/Margin/VBox/HBox/LevelsButton

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
	levels_button.pressed.connect(func():
		AudioManager.play_button_sound()
		levels_pressed.emit()
	)

func show_result(stars: int, level_num: int):
	show_result_full(stars, level_num, 0.0, 0)

func show_result_full(stars: int, level_num: int, elapsed_sec: float, mistakes: int):
	level_label.text = "Level %d Complete!" % level_num
	stars_label.text = "★".repeat(stars) + "☆".repeat(3 - stars)
	time_label.text = "⏱ %.1fs" % elapsed_sec if elapsed_sec > 0 else ""
	mistakes_label.text = "✖ %d mistakes" % mistakes
	_animate_in()

func _apply_styles():
	# Card style box
	var card_style = StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.corner_radius_top_left = 32
	card_style.corner_radius_top_right = 32
	card_style.corner_radius_bottom_left = 32
	card_style.corner_radius_bottom_right = 32
	card_style.shadow_color = Color(0.12, 0.15, 0.22, 0.12)
	card_style.shadow_size = 12
	card_style.shadow_offset = Vector2(0, 6)
	panel.add_theme_stylebox_override("panel", card_style)
	
	# Primary blue next button #3978F6
	var next_style = StyleBoxFlat.new()
	next_style.bg_color = Color("#3978F6")
	next_style.corner_radius_top_left = 24
	next_style.corner_radius_top_right = 24
	next_style.corner_radius_bottom_left = 24
	next_style.corner_radius_bottom_right = 24
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
