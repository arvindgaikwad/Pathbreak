extends CanvasLayer

signal retry_pressed
signal menu_pressed

@onready var panel = $Panel
@onready var retry_button = $Panel/Margin/VBox/RetryButton
@onready var menu_button = $Panel/Margin/VBox/MenuButton

func _ready():
	_apply_styles()
	retry_button.pressed.connect(func():
		AudioManager.play_button_sound()
		retry_pressed.emit()
	)
	menu_button.pressed.connect(func():
		AudioManager.play_button_sound()
		menu_pressed.emit()
	)
	_animate_in()

func _apply_styles():
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
	
	var retry_style = StyleBoxFlat.new()
	retry_style.bg_color = Color("#3978F6")
	retry_style.corner_radius_top_left = 24
	retry_style.corner_radius_top_right = 24
	retry_style.corner_radius_bottom_left = 24
	retry_style.corner_radius_bottom_right = 24
	retry_button.add_theme_stylebox_override("normal", retry_style)
	retry_button.add_theme_stylebox_override("hover", retry_style)
	retry_button.add_theme_stylebox_override("pressed", retry_style)
	retry_button.add_theme_stylebox_override("focus", retry_style)

func _animate_in():
	$Backdrop.modulate.a = 0
	panel.scale = Vector2(0.8, 0.8)
	panel.modulate.a = 0
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Backdrop, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
	tween.tween_property(panel, "scale", Vector2(1.0, 1.0), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
