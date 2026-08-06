extends Control

@onready var play_btn = $UI/VBox/PlayButton
@onready var levels_btn = $UI/VBox/LevelsButton
@onready var title_label = $UI/VBox/TitleLabel
@onready var floating_arrows = $FloatingArrows

var arrow_dirs = ["→", "←", "↑", "↓"]

const COLOR_ACCENT = Color("#3978F6")
const COLOR_PRIMARY_TEXT = Color("#202634")

func _ready():
	play_btn.pressed.connect(_on_play_pressed)
	levels_btn.pressed.connect(_on_levels_pressed)
	_apply_button_styles()
	_spawn_floating_arrows()
	_animate_entrance()

func _apply_button_styles():
	# Play button — primary accent blue #3978F6
	var play_style = StyleBoxFlat.new()
	play_style.bg_color = COLOR_ACCENT
	play_style.corner_radius_top_left = 30
	play_style.corner_radius_top_right = 30
	play_style.corner_radius_bottom_left = 30
	play_style.corner_radius_bottom_right = 30
	play_style.shadow_color = Color(0.22, 0.47, 0.96, 0.25)
	play_style.shadow_size = 8
	play_style.shadow_offset = Vector2(0, 4)
	
	var play_hover = play_style.duplicate()
	play_hover.bg_color = Color("#2F6AE2")
	play_btn.add_theme_stylebox_override("normal", play_style)
	play_btn.add_theme_stylebox_override("hover", play_hover)
	play_btn.add_theme_stylebox_override("pressed", play_hover)
	play_btn.add_theme_stylebox_override("focus", play_style)
	
	# Levels button — white card outline style
	var lvl_style = StyleBoxFlat.new()
	lvl_style.bg_color = Color.WHITE
	lvl_style.border_color = Color("#DDE3EC")
	lvl_style.border_width_left = 2
	lvl_style.border_width_right = 2
	lvl_style.border_width_top = 2
	lvl_style.border_width_bottom = 2
	lvl_style.corner_radius_top_left = 24
	lvl_style.corner_radius_top_right = 24
	lvl_style.corner_radius_bottom_left = 24
	lvl_style.corner_radius_bottom_right = 24
	levels_btn.add_theme_stylebox_override("normal", lvl_style)
	levels_btn.add_theme_stylebox_override("hover", lvl_style)
	levels_btn.add_theme_stylebox_override("pressed", lvl_style)
	levels_btn.add_theme_stylebox_override("focus", lvl_style)
	
	for btn in [play_btn, levels_btn]:
		btn.button_down.connect(func():
			AudioManager.play_button_sound()
			create_tween().tween_property(btn, "scale", Vector2(0.95, 0.95), 0.1).set_trans(Tween.TRANS_SINE)
		)
		btn.button_up.connect(func():
			create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		)
		btn.pivot_offset = btn.size / 2.0

func _animate_entrance():
	title_label.modulate.a = 0
	title_label.position.y += 30
	var tween = create_tween().set_parallel(true)
	tween.tween_property(title_label, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE)
	tween.tween_property(title_label, "position:y", title_label.position.y - 30, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _spawn_floating_arrows():
	for i in range(12):
		var lbl = Label.new()
		lbl.text = arrow_dirs[randi() % 4]
		lbl.add_theme_font_size_override("font_size", randi_range(28, 52))
		lbl.add_theme_color_override("font_color", Color(0.09, 0.125, 0.2, randf_range(0.05, 0.12)))
		lbl.position = Vector2(randf_range(20, 680), randf_range(80, 1200))
		floating_arrows.add_child(lbl)
		_animate_float(lbl)

func _animate_float(node: Node):
	var tween = create_tween().set_loops()
	var start_y = node.position.y
	var offset = randf_range(-25, 25)
	var duration = randf_range(3.5, 6.5)
	tween.tween_property(node, "position:y", start_y + offset, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "position:y", start_y, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_play_pressed():
	SaveManager.current_level = 0
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_levels_pressed():
	get_tree().change_scene_to_file("res://scenes/LevelSelect.tscn")
