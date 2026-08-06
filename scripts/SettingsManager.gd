extends Node

signal settings_changed

const SETTINGS_PATH := "user://settings.json"
const SETTINGS_VERSION := 1

var sound_enabled: bool = true
var music_enabled: bool = true
var haptics_enabled: bool = true
var reduce_motion: bool = false
var high_contrast: bool = false

func _ready() -> void:
	load_settings()

func set_sound_enabled(enabled: bool) -> void:
	sound_enabled = enabled
	_save_and_emit()

func set_music_enabled(enabled: bool) -> void:
	music_enabled = enabled
	_save_and_emit()

func set_haptics_enabled(enabled: bool) -> void:
	haptics_enabled = enabled
	_save_and_emit()

func set_reduce_motion(enabled: bool) -> void:
	reduce_motion = enabled
	_save_and_emit()

func set_high_contrast(enabled: bool) -> void:
	high_contrast = enabled
	_save_and_emit()

func play_haptic(kind: StringName = &"light") -> void:
	if not haptics_enabled or not OS.has_feature("mobile"):
		return

	var duration_ms := 18
	match kind:
		&"success":
			duration_ms = 28
		&"error":
			duration_ms = 55
		&"celebration":
			duration_ms = 80
		_:
			duration_ms = 18
	Input.vibrate_handheld(duration_ms)

func save_settings() -> void:
	var data := {
		"version": SETTINGS_VERSION,
		"sound_enabled": sound_enabled,
		"music_enabled": music_enabled,
		"haptics_enabled": haptics_enabled,
		"reduce_motion": reduce_motion,
		"high_contrast": high_contrast
	}
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Unable to write settings file: %s" % SETTINGS_PATH)
		return
	file.store_string(JSON.stringify(data))

func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return

	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		push_warning("Unable to read settings file. Using defaults.")
		return

	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Settings file is invalid. Using defaults.")
		return

	var data: Dictionary = parsed
	sound_enabled = bool(data.get("sound_enabled", true))
	music_enabled = bool(data.get("music_enabled", true))
	haptics_enabled = bool(data.get("haptics_enabled", true))
	reduce_motion = bool(data.get("reduce_motion", false))
	high_contrast = bool(data.get("high_contrast", false))

func reset_settings() -> void:
	sound_enabled = true
	music_enabled = true
	haptics_enabled = true
	reduce_motion = false
	high_contrast = false
	_save_and_emit()

func _save_and_emit() -> void:
	save_settings()
	settings_changed.emit()
