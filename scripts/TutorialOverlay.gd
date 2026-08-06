extends CanvasLayer

func _ready():
	$Button.pressed.connect(_on_button_pressed)
	# animate the hand up and down
	var tween = create_tween().set_loops()
	tween.tween_property($HandIcon, "position:y", 620.0, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($HandIcon, "position:y", 600.0, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _on_button_pressed():
	queue_free()
