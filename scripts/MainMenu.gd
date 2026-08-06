extends Control

@onready var play_btn: Button = $UI/VBox/PlayButton
@onready var levels_btn: Button = $UI/VBox/LevelsButton
@onready var title_label: Label = $UI/VBox/TitleLabel
@onready var floating_arrows: Control = $FloatingArrows

var arrow_dirs := ["→", "←", "↑", "↓"]

const COLOR_ACCENT := Color("#3978F6")
const COLOR_PRIMARY_TEXT := Color("#202634")

func _ready() -> void:
	play_btn.pressed.connect(_on_play_pressed)
	levels_btn.pressed.connect(_on_levels_pressed)
	play_btn.text = "Continue" if SaveManager.max_level_unlocked > 0 else "Play Game"
	_apply_button_styles()
	_spawn_floating_arrows()
	_animate_entrance()

func _apply_button_styles() -> void:
	var play_style := StyleBoxFlat.new()
	play_style.bg_color = COLOR_ACCENT
	play_style.corner_radius_top_left = 30
	play_style.corner_radius_top_right = 30
	play_style.corner_radius_bottom_left = 30
	play_style.corner_radius_bottom_right = 30
	play_style.shadow_color = Color(0.22, 0.47, 0.96, 0.25)
	play_style.shadow_size = 8
	play_style.shadow_offset = Vector2(0, 4)

	var play_hover := play_style.duplicate()
	play_hover.bg_color = Color("#2F6AE2")
	play_btn.add_theme_stylebox_override("normal", play_style)
	play_btn.add_theme_stylebox_override("hover", play_hover)
	play_btn.add_theme_stylebox_override("pressed", play_hover)
	play_btn.add_theme_stylebox_override("focus", play_style)

	var level_style := StyleBoxFlat.new()
	level_style.bg_color = Color.WHITE
	level_style.border_color = Color("#DDE3EC")
	level_style.border_width_left = 2
	level_style.border_width_right = 2
	level_style.border_width_top = 2
	level_style.border_width_bottom = 2
	level_style.corner_radius_top_left = 24
	level_style.corner_radius_top_right = 24
	level_style.corner_radius_bottom_left = 24
	level_style.corner_radius_bottom_right = 24
	levels_btn.add_theme_stylebox_override("normal", level_style)
	levels_btn.add_theme_stylebox_override("hover", level_style)
	levels_btn.add_theme_stylebox_override("pressed", level_style)
	levels_btn.add_theme_stylebox_override("focus", level_style)

	for button in [play_btn, levels_btn]:
		button.button_down.connect(func() -> void:
			AudioManager.play_button_sound()
			create_tween().tween_property(button, "scale", Vector2(0.95, 0.95), 0.1).set_trans(Tween.TRANS_SINE)
		)
		button.button_up.connect(func() -> void:
			create_tween().tween_property(button, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		)
		button.pivot_offset = button.size / 2.0

func _animate_entrance() -> void:
	title_label.modulate.a = 0.0
	title_label.position.y += 30.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(title_label, "modulate:a", 1.0, 0.6).set_trans(Tween.TRANS_SINE)
	tween.tween_property(title_label, "position:y", title_label.position.y - 30.0, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _spawn_floating_arrows() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in range(12):
		var label := Label.new()
		label.text = arrow_dirs[rng.randi_range(0, arrow_dirs.size() - 1)]
		label.add_theme_font_size_override("font_size", rng.randi_range(28, 52))
		label.add_theme_color_override("font_color", Color(0.09, 0.125, 0.2, rng.randf_range(0.05, 0.12)))
		label.position = Vector2(rng.randf_range(20.0, 680.0), rng.randf_range(80.0, 1200.0))
		floating_arrows.add_child(label)
		_animate_float(label, rng)

func _animate_float(node: Control, rng: RandomNumberGenerator) -> void:
	var tween := create_tween().set_loops()
	var start_y := node.position.y
	var offset := rng.randf_range(-25.0, 25.0)
	var duration := rng.randf_range(3.5, 6.5)
	tween.tween_property(node, "position:y", start_y + offset, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "position:y", start_y, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_play_pressed() -> void:
	SaveManager.current_level = clampi(SaveManager.current_level, 0, SaveManager.max_level_unlocked)
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://scenes/game/game_screen.tscn")

func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LevelSelect.tscn")
