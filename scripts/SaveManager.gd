extends Node

const SAVE_PATH = "user://save.json"

var current_level: int = 0
var max_level_unlocked: int = 0
var hint_count: int = 5
var lives: int = 3
var difficulty: String = "Normal"
var level_stars: Dictionary = {}
var level_best_times: Dictionary = {}
var level_mistakes: Dictionary = {}

func _ready():
	load_game()

func save_game():
	var save_data = {
		"current_level": current_level,
		"max_level_unlocked": max_level_unlocked,
		"hint_count": hint_count,
		"lives": lives,
		"difficulty": difficulty,
		"level_stars": level_stars,
		"level_best_times": level_best_times,
		"level_mistakes": level_mistakes
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))

func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var json = JSON.new()
		if json.parse(file.get_as_text()) == OK:
			var data = json.data
			current_level = data.get("current_level", 0)
			max_level_unlocked = data.get("max_level_unlocked", 0)
			hint_count = data.get("hint_count", 5)
			lives = data.get("lives", 3)
			difficulty = data.get("difficulty", "Normal")
			level_stars = data.get("level_stars", {})
			level_best_times = data.get("level_best_times", {})
			level_mistakes = data.get("level_mistakes", {})
