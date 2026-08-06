extends Node

const SAVE_PATH := "user://save.json"
const SAVE_VERSION := 2

var current_level: int = 0
var max_level_unlocked: int = 0
var hint_count: int = 5
var lives: int = 3
var difficulty: String = "Normal"
var tutorial_completed: bool = false
var level_stars: Dictionary = {}
var level_best_times: Dictionary = {}
var level_best_moves: Dictionary = {}
var level_mistakes: Dictionary = {}

func _ready() -> void:
	load_game()

func save_game() -> void:
	var save_data := {
		"version": SAVE_VERSION,
		"current_level": maxi(current_level, 0),
		"max_level_unlocked": maxi(max_level_unlocked, 0),
		"hint_count": maxi(hint_count, 0),
		"lives": clampi(lives, 0, 9),
		"difficulty": difficulty,
		"tutorial_completed": tutorial_completed,
		"level_stars": level_stars,
		"level_best_times": level_best_times,
		"level_best_moves": level_best_moves,
		"level_mistakes": level_mistakes
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Unable to open save file for writing: %s" % SAVE_PATH)
		return
	file.store_string(JSON.stringify(save_data))

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		reset_progress(false)
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("Unable to read save file. Using defaults.")
		reset_progress(false)
		return

	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Save file is invalid. Using defaults.")
		reset_progress(false)
		return

	var data: Dictionary = parsed
	current_level = maxi(int(data.get("current_level", 0)), 0)
	max_level_unlocked = maxi(int(data.get("max_level_unlocked", 0)), 0)
	hint_count = maxi(int(data.get("hint_count", 5)), 0)
	lives = clampi(int(data.get("lives", 3)), 0, 9)
	difficulty = str(data.get("difficulty", "Normal"))
	tutorial_completed = bool(data.get("tutorial_completed", max_level_unlocked > 0))
	level_stars = _dictionary_or_empty(data.get("level_stars", {}))
	level_best_times = _dictionary_or_empty(data.get("level_best_times", {}))
	level_best_moves = _dictionary_or_empty(data.get("level_best_moves", {}))
	level_mistakes = _dictionary_or_empty(data.get("level_mistakes", {}))

func record_level_completion(
	level_index: int,
	stars: int,
	elapsed_seconds: float,
	moves: int,
	mistakes: int,
	total_levels: int
) -> void:
	var key := str(level_index)
	level_stars[key] = maxi(int(level_stars.get(key, 0)), clampi(stars, 1, 3))

	var previous_time := float(level_best_times.get(key, 0.0))
	if previous_time <= 0.0 or elapsed_seconds < previous_time:
		level_best_times[key] = elapsed_seconds

	var previous_moves := int(level_best_moves.get(key, -1))
	if previous_moves < 0 or moves < previous_moves:
		level_best_moves[key] = moves

	var previous_mistakes := int(level_mistakes.get(key, -1))
	if previous_mistakes < 0 or mistakes < previous_mistakes:
		level_mistakes[key] = mistakes

	if level_index == 0:
		tutorial_completed = true
	max_level_unlocked = mini(maxi(max_level_unlocked, level_index + 1), maxi(total_levels - 1, 0))
	current_level = mini(level_index + 1, maxi(total_levels - 1, 0))
	save_game()

func reset_progress(write_to_disk: bool = true) -> void:
	current_level = 0
	max_level_unlocked = 0
	hint_count = 5
	lives = 3
	difficulty = "Normal"
	tutorial_completed = false
	level_stars.clear()
	level_best_times.clear()
	level_best_moves.clear()
	level_mistakes.clear()
	if write_to_disk:
		save_game()

func _dictionary_or_empty(value: Variant) -> Dictionary:
	return value if value is Dictionary else {}
