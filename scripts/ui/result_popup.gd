extends CanvasLayer

signal next_pressed
signal replay_pressed

@onready var panel: PanelContainer = $Panel
@onready var title_label: Label = $Panel/Margin/VBox/TitleLabel
@onready var sub_label: Label = $Panel/Margin/VBox/SubLabel
@onready var stats_box: VBoxContainer = $Panel/Margin/VBox/StatsContainer/VBox
@onready var time_value: Label = $Panel/Margin/VBox/StatsContainer/VBox/TimeRow/TimeValue
@onready var moves_label: Label = $Panel/Margin/VBox/StatsContainer/VBox/MovesRow/MovesLabel
@onready var moves_value: Label = $Panel/Margin/VBox/StatsContainer/VBox/MovesRow/MovesValue
@onready var hints_value: Label = $Panel/Margin/VBox/StatsContainer/VBox/HintsRow/HintsValue
@onready var stars_label: Label = $Panel/Margin/VBox/StarRating/StarsLabel
@onready var next_button: Button = $Panel/Margin/VBox/HBoxButtons/NextButton
@onready var replay_button: Button = $Panel/Margin/VBox/HBoxButtons/ReplayButton

var mistakes_value: Label

const COLOR_ACCENT := Color("#2563EB")
const COLOR_SECONDARY_TEXT := Color("#717D93")
const COLOR_ERROR := Color("#EF5B5B")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_create_mistakes_row()
	_apply_styles()
	moves_label.text = "⇄  Moves"
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
	var minutes := int(total_seconds / 60)
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
	_animate_in()

func _create_mistakes_row() -> void:
	var row := HBoxContainer.new()
	row.name = "MistakesRow"

	var label := Label.new()
	label.text = "!  Mistakes"
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_color_override("font_color", COLOR_SECONDARY_TEXT)
	label.add_theme_font_size_override("font_size", 18)
	row.add_child(label)

	mistakes_value = Label.new()
	mistakes_value.text = "0"
	mistakes_value.add_theme_color_override("font_color", COLOR_ERROR)
	mistakes_value.add_theme_font_size_override("font_size", 18)
	row.add_child(mistakes_value)

	stats_box.add_child(row)
	stats_box.move_child(row, 2)

func _apply_styles() -> void:
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.corner_radius_top_left = 36
	card_style.corner_radius_top_right = 36
	card_style.corner_radius_bottom_left = 36
	card_style.corner_radius_bottom_right = 36
	card_style.shadow_color = Color(0.1, 0.12, 0.18, 0.12)
	card_style.shadow_size = 16
	card_style.shadow_offset = Vector2(0, 8)
	panel.add_theme_stylebox_override("panel", card_style)

	var replay_style := StyleBoxFlat.new()
	replay_style.bg_color = Color.WHITE
	replay_style.border_color = COLOR_ACCENT
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

	var next_style := StyleBoxFlat.new()
	next_style.bg_color = COLOR_ACCENT
	next_style.corner_radius_top_left = 20
	next_style.corner_radius_top_right = 20
	next_style.corner_radius_bottom_left = 20
	next_style.corner_radius_bottom_right = 20
	next_button.add_theme_stylebox_override("normal", next_style)
	next_button.add_theme_stylebox_override("hover", next_style)
	next_button.add_theme_stylebox_override("pressed", next_style)
	next_button.add_theme_stylebox_override("focus", next_style)

func _animate_in() -> void:
	if SettingsManager.reduce_motion:
		return
	$Backdrop.modulate.a = 0.0
	panel.scale = Vector2(0.86, 0.86)
	panel.modulate.a = 0.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property($Backdrop, "modulate:a", 1.0, 0.24).set_trans(Tween.TRANS_SINE)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.36).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.24).set_trans(Tween.TRANS_SINE)
