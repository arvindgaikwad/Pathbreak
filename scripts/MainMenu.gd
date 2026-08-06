extends Control

@onready var play_btn: Button = $UI/VBox/PlayButton
@onready var levels_btn: Button = $UI/VBox/LevelsButton
@onready var title_label: Label = $UI/VBox/TitleLabel
@onready var logo_mark: Label = $UI/VBox/LogoMark
@onready var progress_pill: Label = $UI/VBox/ProgressPill
@onready var floating_arrows: Control = $FloatingArrows

const TOTAL_LEVELS := 10
const COLOR_ACCENT := Color("#3978F6")
const COLOR_ACCENT_DARK := Color("#2F6AE2")
const COLOR_PRIMARY_TEXT := Color("#202634")
const COLOR_BORDER := Color("#DDE3EC")

var arrow_dirs: Array[String] = ["→", "←", "↑", "↓"]

func _ready() -> void:
	play_btn.pressed.connect(_on_play_pressed)
	levels_btn.pressed.connect(_on_levels_pressed)
	_update_progress_copy()
	_apply_button_styles()
	_apply_progress_style()
	_spawn_floating_arrows()
	_animate_entrance()

func _update_progress_copy() -> void:
	var completed := SaveManager.level_stars.size()
	var total_stars := 0
	for value in SaveManager.level_stars.values():
		total_stars += int(value)

	if completed <= 0:
		play_btn.text = "Start Journey"
		progress_pill.text = "%d handcrafted levels  ·  No timers" % TOTAL_LEVELS
	else:
		var next_level := clampi(SaveManager.current_level + 1, 1, TOTAL_LEVELS)
		play_btn.text = "Continue Level %d" % next_level
		progress_pill.text = "%d / %d cleared  ·  %d stars earned" % [completed, TOTAL_LEVELS, total_stars]

func _apply_progress_style() -> void:
	var pill_style := StyleBoxFlat.new()
	pill_style.bg_color = Color("#EEF4FF")
	pill_style.border_color = Color("#D7E5FF")
	pill_style.border_width_left = 1
	pill_style.border_width_top = 1
	pill_style.border_width_right = 1
	pill_style.border_width_bottom = 1
	pill_style.corner_radius_top_left = 21
	pill_style.corner_radius_top_right = 21
	pill_style.corner_radius_bottom_left = 21
	pill_style.corner_radius_bottom_right = 21
	pill_style.content_margin_left = 18
	pill_style.content_margin_right = 18
	progress_pill.add_theme_stylebox_override("normal", pill_style)

func _apply_button_styles() -> void:
	var play_style := StyleBoxFlat.new()
	play_style.bg_color = COLOR_ACCENT
	play_style.corner_radius_top_left = 26
	play_style.corner_radius_top_right = 26
	play_style.corner_radius_bottom_left = 26
	play_style.corner_radius_bottom_right = 26
	play_style.shadow_color = Color(0.22, 0.47, 0.96, 0.22)
	play_style.shadow_size = 8
	play_style.shadow_offset = Vector2(0, 4)

	var play_hover := play_style.duplicate() as StyleBoxFlat
	play_hover.bg_color = COLOR_ACCENT_DARK
	play_btn.add_theme_stylebox_override("normal", play_style)
	play_btn.add_theme_stylebox_override("hover", play_hover)
	play_btn.add_theme_stylebox_override("pressed", play_hover)
	play_btn.add_theme_stylebox_override("focus", play_style)

	var level_style := StyleBoxFlat.new()
	level_style.bg_color = Color.WHITE
	level_style.border_color = COLOR_BORDER
	level_style.border_width_left = 2
	level_style.border_width_right = 2
	level_style.border_width_top = 2
	level_style.border_width_bottom = 2
	level_style.corner_radius_top_left = 22
	level_style.corner_radius_top_right = 22
	level_style.corner_radius_bottom_left = 22
	level_style.corner_radius_bottom_right = 22

	var level_pressed := level_style.duplicate() as StyleBoxFlat
	level_pressed.bg_color = Color("#F2F5F9")
	levels_btn.add_theme_stylebox_override("normal", level_style)
	levels_btn.add_theme_stylebox_override("hover", level_pressed)
	levels_btn.add_theme_stylebox_override("pressed", level_pressed)
	levels_btn.add_theme_stylebox_override("focus", level_style)

	for button in [play_btn, levels_btn]:
		button.button_down.connect(func() -> void:
			AudioManager.play_button_sound()
			create_tween().tween_property(button, "scale", Vector2(0.97, 0.97), 0.08).set_trans(Tween.TRANS_SINE)
		)
		button.button_up.connect(func() -> void:
			create_tween().tween_property(button, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		)
		button.pivot_offset = button.custom_minimum_size * 0.5

func _animate_entrance() -> void:
	if SettingsManager.reduce_motion:
		return
	for node in [logo_mark, title_label, progress_pill, play_btn, levels_btn]:
		node.modulate.a = 0.0
		node.position.y += 18.0

	var tween := create_tween().set_parallel(true)
	var delay := 0.0
	for node in [logo_mark, title_label, progress_pill, play_btn, levels_btn]:
		tween.tween_property(node, "modulate:a", 1.0, 0.35).set_delay(delay)
		tween.tween_property(node, "position:y", node.position.y - 18.0, 0.42).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		delay += 0.05

func _spawn_floating_arrows() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var viewport_size := get_viewport_rect().size
	var arrow_count := 5 if SettingsManager.reduce_motion else 8
	for index in range(arrow_count):
		var label := Label.new()
		label.text = arrow_dirs[rng.randi_range(0, arrow_dirs.size() - 1)]
		label.add_theme_font_size_override("font_size", rng.randi_range(24, 38))
		label.add_theme_color_override("font_color", Color(0.09, 0.125, 0.2, rng.randf_range(0.035, 0.075)))
		label.position = Vector2(
			rng.randf_range(18.0, maxf(viewport_size.x - 58.0, 60.0)),
			rng.randf_range(54.0, maxf(viewport_size.y - 86.0, 120.0))
		)
		floating_arrows.add_child(label)
		if not SettingsManager.reduce_motion:
			_animate_float(label, rng)

func _animate_float(node: Control, rng: RandomNumberGenerator) -> void:
	var tween := create_tween().set_loops()
	var start_y := node.position.y
	var offset := rng.randf_range(-16.0, 16.0)
	var duration := rng.randf_range(4.5, 7.0)
	tween.tween_property(node, "position:y", start_y + offset, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "position:y", start_y, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_play_pressed() -> void:
	SaveManager.current_level = clampi(SaveManager.current_level, 0, SaveManager.max_level_unlocked)
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://scenes/game/game_screen.tscn")

func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/LevelSelect.tscn")
