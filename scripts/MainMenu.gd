extends Control

const HowToPlayOverlayScene: PackedScene = preload("res://scenes/shared/how_to_play_overlay.tscn")
const SettingsOverlayScene: PackedScene = preload("res://scenes/shared/settings_overlay.tscn")

const TOTAL_LEVELS := 10
const COLOR_ACCENT := Color("#3978F6")
const COLOR_ACCENT_DARK := Color("#2F6AE2")
const COLOR_PRIMARY := Color("#1B2538")
const COLOR_SECONDARY := Color("#717D93")
const COLOR_BORDER := Color("#E1E7EF")

@onready var star_label: Label = $SafeMargin/Content/TopRow/StarLabel
@onready var settings_button: Button = $SafeMargin/Content/TopRow/SettingsButton
@onready var hero: VBoxContainer = $SafeMargin/Content/Hero
@onready var board_center: CenterContainer = $SafeMargin/Content/BoardCenter
@onready var board_button: Button = $SafeMargin/Content/BoardCenter/BoardOverlay/ClickTarget
@onready var board_prompt: Label = $SafeMargin/Content/BoardCenter/BoardOverlay/PromptLabel
@onready var progress_card: PanelContainer = $SafeMargin/Content/ProgressCard
@onready var chapter_label: Label = $SafeMargin/Content/ProgressCard/CardMargin/CardContent/ChapterLabel
@onready var level_label: Label = $SafeMargin/Content/ProgressCard/CardMargin/CardContent/LevelRow/LevelLabel
@onready var progress_label: Label = $SafeMargin/Content/ProgressCard/CardMargin/CardContent/LevelRow/ProgressLabel
@onready var progress_bar: ProgressBar = $SafeMargin/Content/ProgressCard/CardMargin/CardContent/ProgressBar
@onready var primary_button: Button = $SafeMargin/Content/ProgressCard/CardMargin/CardContent/PrimaryButton
@onready var secondary_row: HBoxContainer = $SafeMargin/Content/SecondaryRow
@onready var levels_button: Button = $SafeMargin/Content/SecondaryRow/LevelsButton
@onready var how_to_button: Button = $SafeMargin/Content/SecondaryRow/HowToButton

var primary_level_index: int = 0
var active_overlay: CanvasLayer = null
var navigation_started: bool = false

func _ready() -> void:
	primary_button.pressed.connect(_on_primary_pressed)
	board_button.pressed.connect(_on_board_pressed)
	levels_button.pressed.connect(_on_levels_pressed)
	how_to_button.pressed.connect(_on_how_to_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	_apply_styles()
	_refresh_state()
	_prepare_button_feedback()
	_animate_entrance()

func _refresh_state() -> void:
	var completed := _completed_level_count()
	var total_stars := _total_stars()
	var all_complete := completed >= TOTAL_LEVELS
	var new_player := completed == 0 and SaveManager.max_level_unlocked == 0

	star_label.text = "★  %d" % total_stars
	progress_bar.value = (float(completed) / float(TOTAL_LEVELS)) * 100.0

	if new_player:
		primary_level_index = 0
		chapter_label.text = "CHAPTER 1 · FIRST PATHS"
		level_label.text = "Begin with one clear route"
		progress_label.text = "0 / %d" % TOTAL_LEVELS
		primary_button.text = "Start Level 1"
		board_prompt.text = "TAP THE BOARD TO START"
	elif all_complete:
		primary_level_index = TOTAL_LEVELS - 1
		chapter_label.text = "CHAPTER 1 COMPLETE"
		level_label.text = "Every path cleared"
		progress_label.text = "%d / %d" % [TOTAL_LEVELS, TOTAL_LEVELS]
		primary_button.text = "Replay Level %d" % TOTAL_LEVELS
		board_prompt.text = "TAP TO REPLAY · LEVEL %d" % TOTAL_LEVELS
	else:
		primary_level_index = _get_recommended_level_index()
		chapter_label.text = "CHAPTER 1 · FIRST PATHS"
		level_label.text = "Level %d" % (primary_level_index + 1)
		progress_label.text = "%d / %d cleared" % [completed, TOTAL_LEVELS]
		primary_button.text = "Continue · Level %d" % (primary_level_index + 1)
		board_prompt.text = "TAP TO CONTINUE · LEVEL %d" % (primary_level_index + 1)

func _completed_level_count() -> int:
	var completed := 0
	for level_index in range(TOTAL_LEVELS):
		if int(SaveManager.level_stars.get(str(level_index), 0)) > 0:
			completed += 1
	return completed

func _total_stars() -> int:
	var total := 0
	for value in SaveManager.level_stars.values():
		total += maxi(int(value), 0)
	return total

func _get_recommended_level_index() -> int:
	var max_available := clampi(SaveManager.max_level_unlocked, 0, TOTAL_LEVELS - 1)
	for level_index in range(max_available + 1):
		if int(SaveManager.level_stars.get(str(level_index), 0)) <= 0:
			return level_index
	return max_available

func _apply_styles() -> void:
	progress_card.add_theme_stylebox_override("panel", _card_style())
	primary_button.add_theme_stylebox_override("normal", _primary_button_style(COLOR_ACCENT))
	primary_button.add_theme_stylebox_override("hover", _primary_button_style(COLOR_ACCENT_DARK))
	primary_button.add_theme_stylebox_override("pressed", _primary_button_style(COLOR_ACCENT_DARK))
	primary_button.add_theme_stylebox_override("focus", _primary_button_style(COLOR_ACCENT))

	for button: Button in [levels_button, how_to_button]:
		button.add_theme_stylebox_override("normal", _secondary_button_style(Color.WHITE))
		button.add_theme_stylebox_override("hover", _secondary_button_style(Color("#F1F4F8")))
		button.add_theme_stylebox_override("pressed", _secondary_button_style(Color("#EDF1F6")))
		button.add_theme_stylebox_override("focus", _secondary_button_style(Color.WHITE))

	settings_button.add_theme_stylebox_override("normal", _utility_button_style(Color.WHITE))
	settings_button.add_theme_stylebox_override("hover", _utility_button_style(Color("#F1F4F8")))
	settings_button.add_theme_stylebox_override("pressed", _utility_button_style(Color("#EDF1F6")))
	settings_button.add_theme_stylebox_override("focus", _utility_button_style(Color.WHITE))
	star_label.add_theme_stylebox_override("normal", _star_pill_style())
	board_prompt.add_theme_stylebox_override("normal", _board_prompt_style())

	var progress_background := StyleBoxFlat.new()
	progress_background.bg_color = Color("#E9EDF3")
	progress_background.corner_radius_top_left = 7
	progress_background.corner_radius_top_right = 7
	progress_background.corner_radius_bottom_left = 7
	progress_background.corner_radius_bottom_right = 7
	progress_bar.add_theme_stylebox_override("background", progress_background)

	var progress_fill := StyleBoxFlat.new()
	progress_fill.bg_color = COLOR_ACCENT
	progress_fill.corner_radius_top_left = 7
	progress_fill.corner_radius_top_right = 7
	progress_fill.corner_radius_bottom_left = 7
	progress_fill.corner_radius_bottom_right = 7
	progress_bar.add_theme_stylebox_override("fill", progress_fill)

func _prepare_button_feedback() -> void:
	var buttons: Array[Button] = [primary_button, levels_button, how_to_button, settings_button]
	for button in buttons:
		button.button_down.connect(func() -> void:
			AudioManager.play_button_sound()
			create_tween().tween_property(button, "scale", Vector2(0.97, 0.97), 0.07).set_trans(Tween.TRANS_SINE)
		)
		button.button_up.connect(func() -> void:
			create_tween().tween_property(button, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		)
		button.pivot_offset = button.custom_minimum_size * 0.5

func _animate_entrance() -> void:
	var sections: Array[Control] = [hero, board_center, progress_card, secondary_row]
	for section in sections:
		section.modulate.a = 1.0

	if SettingsManager.reduce_motion:
		return

	for section in sections:
		section.modulate.a = 0.0

	var tween := create_tween().set_parallel(true)
	var delay := 0.0
	for section in sections:
		tween.tween_property(section, "modulate:a", 1.0, 0.34).set_delay(delay).set_trans(Tween.TRANS_SINE)
		delay += 0.08

func _on_primary_pressed() -> void:
	_start_primary_level()

func _on_board_pressed() -> void:
	if navigation_started:
		return
	AudioManager.play_button_sound()
	if SettingsManager.reduce_motion:
		_start_primary_level()
		return

	board_center.pivot_offset = board_center.size * 0.5
	var tween := create_tween()
	tween.tween_property(board_center, "scale", Vector2(0.985, 0.985), 0.07).set_trans(Tween.TRANS_SINE)
	tween.tween_property(board_center, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.finished.connect(_start_primary_level)

func _start_primary_level() -> void:
	if navigation_started:
		return
	navigation_started = true
	SaveManager.current_level = primary_level_index
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://scenes/game/game_screen.tscn")

func _on_levels_pressed() -> void:
	if navigation_started:
		return
	navigation_started = true
	get_tree().change_scene_to_file("res://scenes/LevelSelect.tscn")

func _on_how_to_pressed() -> void:
	_open_overlay(HowToPlayOverlayScene)

func _on_settings_pressed() -> void:
	_open_overlay(SettingsOverlayScene)

func _open_overlay(scene: PackedScene) -> void:
	if active_overlay != null and is_instance_valid(active_overlay):
		return
	active_overlay = scene.instantiate() as CanvasLayer
	if active_overlay == null:
		push_error("Main-menu overlay scene must use a CanvasLayer root.")
		return
	add_child(active_overlay)
	if active_overlay.has_signal("closed"):
		active_overlay.connect("closed", func() -> void: active_overlay = null)

func _card_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color.WHITE
	style.border_color = COLOR_BORDER
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 28
	style.corner_radius_top_right = 28
	style.corner_radius_bottom_left = 28
	style.corner_radius_bottom_right = 28
	style.shadow_color = Color(0.08, 0.10, 0.16, 0.08)
	style.shadow_size = 10
	style.shadow_offset = Vector2(0.0, 5.0)
	return style

func _primary_button_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 22
	style.corner_radius_top_right = 22
	style.corner_radius_bottom_left = 22
	style.corner_radius_bottom_right = 22
	style.shadow_color = Color(0.22, 0.47, 0.96, 0.20)
	style.shadow_size = 7
	style.shadow_offset = Vector2(0.0, 4.0)
	return style

func _secondary_button_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = COLOR_BORDER
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	return style

func _utility_button_style(color: Color) -> StyleBoxFlat:
	var style := _secondary_button_style(color)
	style.corner_radius_top_left = 25
	style.corner_radius_top_right = 25
	style.corner_radius_bottom_left = 25
	style.corner_radius_bottom_right = 25
	return style

func _star_pill_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#FFF7E4")
	style.border_color = Color("#FFE1A3")
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	style.content_margin_left = 15
	style.content_margin_right = 15
	return style

func _board_prompt_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 1.0, 1.0, 0.94)
	style.border_color = Color("#D9E7FF")
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14
	style.content_margin_left = 10
	style.content_margin_right = 10
	return style
