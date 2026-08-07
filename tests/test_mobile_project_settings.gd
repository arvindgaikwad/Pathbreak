extends SceneTree

func _init() -> void:
	print("--- Running Pathbreak Mobile Project Settings Test ---")
	var viewport_width := int(ProjectSettings.get_setting("display/window/size/viewport_width", 0))
	var viewport_height := int(ProjectSettings.get_setting("display/window/size/viewport_height", 0))
	var orientation := int(ProjectSettings.get_setting("display/window/handheld/orientation", -1))

	var passed := true
	if viewport_width <= 0 or viewport_height <= 0:
		push_error("Viewport dimensions must be positive.")
		passed = false
	if viewport_width >= viewport_height:
		push_error(
			"Pathbreak is portrait-first, but viewport is %dx%d." % [
				viewport_width,
				viewport_height
			]
		)
		passed = false
	if orientation != DisplayServer.SCREEN_PORTRAIT:
		push_error(
			"Mobile orientation must be SCREEN_PORTRAIT (1), found %d." % orientation
		)
		passed = false

	print(
		"Mobile settings: viewport=%dx%d orientation=%d (%s)" % [
			viewport_width,
			viewport_height,
			orientation,
			"portrait" if orientation == DisplayServer.SCREEN_PORTRAIT else "not portrait"
		]
	)
	print("Mobile project settings: %s" % ("PASS" if passed else "FAIL"))
	quit(0 if passed else 1)
