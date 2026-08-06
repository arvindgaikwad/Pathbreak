extends CanvasLayer
class_name HintRefillPopup

signal refill_pressed
signal cancelled

@onready var backdrop: ColorRect = $Backdrop
@onready var panel: PanelContainer = $Panel
@onready var amount_card: PanelContainer = $Panel/Margin/VBox/AmountCard
@onready var refill_button: Button = $Panel/Margin/VBox/RefillButton
@onready var cancel_button: Button = $Panel/Margin/VBox/CancelButton

const COLOR_ACCENT := Color("#3B82F6")
const COLOR_ACCENT_PRESSED := Color("#2563EB")
const COLOR_BORDER := Color("#E7EBF1")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_apply_styles()
	refill_button.pressed.connect(_on_refill_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	backdrop.gui_input.connect(_on_backdrop_input)
	_animate_in()

func _apply_styles() -> void:
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color.WHITE
	panel_style.border_color = COLOR_BORDER
	panel_style.border_width_left = 1
	panel_style.border_width_top = 1
	panel_style.border_width_right = 1
	panel_style.border_width_bottom = 1
	panel_style.corner_radius_top_left = 28
	panel_style.corner_radius_top_right = 28
	panel_style.corner_radius_bottom_left = 28
	panel_style.corner_radius_bottom_right = 28
	panel_style.shadow_color = Color(0.08, 0.11, 0.18, 0.14)
	panel_style.shadow_size = 18
	panel_style.shadow_offset = Vector2(0, 8)
	panel.add_theme_stylebox_override("panel", panel_style)

	var amount_style := StyleBoxFlat.new()
	amount_style.bg_color = Color("#EEF4FF")
	amount_style.border_color = Color("#D9E7FF")
	amount_style.border_width_left = 1
	amount_style.border_width_top = 1
	amount_style.border_width_right = 1
	amount_style.border_width_bottom = 1
	amount_style.corner_radius_top_left = 18
	amount_style.corner_radius_top_right = 18
	amount_style.corner_radius_bottom_left = 18
	amount_style.corner_radius_bottom_right = 18
	amount_card.add_theme_stylebox_override("panel", amount_style)

	var refill_normal := StyleBoxFlat.new()
	refill_normal.bg_color = COLOR_ACCENT
	refill_normal.corner_radius_top_left = 18
	refill_normal.corner_radius_top_right = 18
	refill_normal.corner_radius_bottom_left = 18
	refill_normal.corner_radius_bottom_right = 18

	var refill_pressed_style := refill_normal.duplicate() as StyleBoxFlat
	refill_pressed_style.bg_color = COLOR_ACCENT_PRESSED
	refill_button.add_theme_stylebox_override("normal", refill_normal)
	refill_button.add_theme_stylebox_override("hover", refill_normal)
	refill_button.add_theme_stylebox_override("pressed", refill_pressed_style)
	refill_button.add_theme_stylebox_override("focus", refill_normal)

	var cancel_normal := StyleBoxFlat.new()
	cancel_normal.bg_color = Color.WHITE
	cancel_normal.border_color = COLOR_BORDER
	cancel_normal.border_width_left = 1
	cancel_normal.border_width_top = 1
	cancel_normal.border_width_right = 1
	cancel_normal.border_width_bottom = 1
	cancel_normal.corner_radius_top_left = 18
	cancel_normal.corner_radius_top_right = 18
	cancel_normal.corner_radius_bottom_left = 18
	cancel_normal.corner_radius_bottom_right = 18

	var cancel_pressed_style := cancel_normal.duplicate() as StyleBoxFlat
	cancel_pressed_style.bg_color = Color("#F3F6FA")
	cancel_button.add_theme_stylebox_override("normal", cancel_normal)
	cancel_button.add_theme_stylebox_override("hover", cancel_pressed_style)
	cancel_button.add_theme_stylebox_override("pressed", cancel_pressed_style)
	cancel_button.add_theme_stylebox_override("focus", cancel_normal)

func _animate_in() -> void:
	panel.scale = Vector2(0.88, 0.88)
	panel.modulate.a = 0.0
	backdrop.modulate.a = 0.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(backdrop, "modulate:a", 1.0, 0.16)
	tween.tween_property(panel, "modulate:a", 1.0, 0.18)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_refill_pressed() -> void:
	AudioManager.play_button_sound()
	refill_pressed.emit()

func _on_cancel_pressed() -> void:
	AudioManager.play_button_sound()
	cancelled.emit()

func _on_backdrop_input(event: InputEvent) -> void:
	var activated: bool = (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	) or (event is InputEventScreenTouch and event.pressed)
	if activated:
		cancelled.emit()
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		cancelled.emit()
		get_viewport().set_input_as_handled()
