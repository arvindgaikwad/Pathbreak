extends Node2D

var PuzzlePieceScene = preload("res://scenes/PuzzlePiece.tscn")
var VictoryScreenScene = preload("res://scenes/VictoryScreen.tscn")
var GameOverScreenScene = preload("res://scenes/GameOverScreen.tscn")

var levels: Array = [
	"res://data/level1.json",
	"res://data/level2.json",
	"res://data/level3.json",
	"res://data/level4.json",
	"res://data/level5.json",
	"res://data/level6.json",
	"res://data/level7.json",
	"res://data/level8.json",
	"res://data/level9.json",
	"res://data/level10.json"
]

var current_level_idx: int = 0
var current_level_data: PuzzleLevelData
var occupied: Dictionary = {}
var pieces_remaining: int = 0
var board_bounds := Rect2i(0, 0, 8, 8)
var grid_size := 64.0
var hints_left: int = 5

var level_start_time_msec: int = 0
var mistake_count: int = 0

@onready var pieces_container = $BoardPivot/PiecesContainer
@onready var grid_dots = $GridDots
@onready var level_label = $HUD/TopBar/LevelLabel
@onready var restart_button = $HUD/BottomBar/RestartButton
@onready var hint_button = $HUD/BottomBar/HintButton
@onready var back_button = $HUD/TopBar/BackButton

var mistake_label: Label
var hint_badge: Label

# Pathbreak Colors
const COLOR_PRIMARY_TEXT = Color("#202634")
const COLOR_SECONDARY_TEXT = Color("#727B8C")
const COLOR_ACCENT = Color("#3978F6")
const COLOR_ERROR = Color("#EF5B5B")
const COLOR_SUCCESS = Color("#35B779")

func _ready():
	_setup_ui_styles()
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	if hint_button:
		hint_button.pressed.connect(_on_hint_pressed)
	if back_button:
		back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	
	current_level_idx = SaveManager.current_level
	hints_left = SaveManager.hint_count
	
	_load_current_level()

func _setup_ui_styles():
	var pill_style = StyleBoxFlat.new()
	pill_style.bg_color = Color("#FFFFFF")
	pill_style.border_color = Color("#DDE3EC")
	pill_style.border_width_left = 1
	pill_style.border_width_right = 1
	pill_style.border_width_top = 1
	pill_style.border_width_bottom = 1
	pill_style.corner_radius_top_left = 20
	pill_style.corner_radius_top_right = 20
	pill_style.corner_radius_bottom_left = 20
	pill_style.corner_radius_bottom_right = 20
	
	level_label.add_theme_color_override("font_color", COLOR_PRIMARY_TEXT)
	
	if has_node("HUD/TopBar/DifficultyPill/DiffLabel"):
		get_node("HUD/TopBar/DifficultyPill/DiffLabel").add_theme_color_override("font_color", COLOR_SECONDARY_TEXT)
	
	var score_pill = $HUD/TopBar/ScorePill
	var diff_pill = $HUD/TopBar/DifficultyPill
	if score_pill is ColorRect:
		var p1 = Panel.new()
		p1.add_theme_stylebox_override("panel", pill_style)
		p1.position = score_pill.position
		p1.size = score_pill.size
		score_pill.get_parent().add_child(p1)
		for c in score_pill.get_children():
			score_pill.remove_child(c)
			p1.add_child(c)
		score_pill.queue_free()
		score_pill = p1
		
	if diff_pill is ColorRect:
		var p2 = Panel.new()
		p2.add_theme_stylebox_override("panel", pill_style)
		p2.position = diff_pill.position
		p2.size = diff_pill.size
		diff_pill.get_parent().add_child(p2)
		for c in diff_pill.get_children():
			diff_pill.remove_child(c)
			p2.add_child(c)
		diff_pill.queue_free()
		diff_pill = p2

	# Repurpose ScoreLabel to be Mistake Counter Label
	if has_node("HUD/TopBar/ScorePill/ScoreLabel"):
		mistake_label = get_node("HUD/TopBar/ScorePill/ScoreLabel") as Label
		mistake_label.add_theme_color_override("font_color", COLOR_ERROR)

	# Circular buttons for bottom bar
	var circle_style = StyleBoxFlat.new()
	circle_style.bg_color = Color.WHITE
	circle_style.corner_radius_top_left = 50
	circle_style.corner_radius_top_right = 50
	circle_style.corner_radius_bottom_left = 50
	circle_style.corner_radius_bottom_right = 50
	circle_style.shadow_color = Color(0, 0, 0, 0.08)
	circle_style.shadow_size = 4
	circle_style.shadow_offset = Vector2(0, 4)
	
	var hover_style = circle_style.duplicate()
	hover_style.bg_color = Color(0.96, 0.96, 0.96)
	
	for btn in [restart_button, hint_button, $HUD/BottomBar/GridButton]:
		if not btn:
			continue
		btn.add_theme_stylebox_override("normal", circle_style)
		btn.add_theme_stylebox_override("hover", hover_style)
		btn.add_theme_stylebox_override("pressed", hover_style)
		btn.add_theme_stylebox_override("focus", circle_style)
		
		if btn.name == "RestartButton":
			btn.text = ""
			btn.icon = load("res://assets/refresh.svg")
		elif btn.name == "HintButton":
			btn.text = ""
			btn.icon = load("res://assets/hint.svg")
		elif btn.name == "GridButton":
			btn.text = ""
			btn.icon = load("res://assets/grid.svg")
			
		btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			
		btn.button_down.connect(func():
			create_tween().tween_property(btn, "scale", Vector2(0.92, 0.92), 0.1).set_trans(Tween.TRANS_SINE)
		)
		btn.button_up.connect(func():
			create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		)
		btn.pivot_offset = btn.size / 2.0
	
	# Hint badge
	hint_badge = Label.new()
	hint_badge.text = str(hints_left)
	hint_badge.add_theme_font_size_override("font_size", 14)
	hint_badge.add_theme_color_override("font_color", Color.WHITE)
	var badge_bg = StyleBoxFlat.new()
	badge_bg.bg_color = COLOR_ACCENT
	badge_bg.corner_radius_top_left = 12
	badge_bg.corner_radius_top_right = 12
	badge_bg.corner_radius_bottom_left = 12
	badge_bg.corner_radius_bottom_right = 12
	badge_bg.content_margin_left = 6
	badge_bg.content_margin_right = 6
	badge_bg.content_margin_top = 2
	badge_bg.content_margin_bottom = 2
	hint_badge.add_theme_stylebox_override("normal", badge_bg)
	hint_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_badge.position = hint_button.position + Vector2(68, -10)
	$HUD/BottomBar.add_child(hint_badge)

func _load_current_level():
	for child in pieces_container.get_children():
		if child is PuzzlePiece:
			child.queue_free()
	occupied.clear()
	mistake_count = 0
	level_start_time_msec = Time.get_ticks_msec()
	_update_ui()
	
	if current_level_idx >= levels.size():
		level_label.text = "All Clear!"
		return
		
	var tween = create_tween().set_parallel(true)
	var top_bar = $HUD/TopBar
	var bot_bar = $HUD/BottomBar
	top_bar.position.y = -200
	bot_bar.position.y = 1280
	tween.tween_property(top_bar, "position:y", 0.0, 0.45).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(bot_bar, "position:y", 1100.0, 0.45).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		
	var level_path = levels[current_level_idx]
	if not FileAccess.file_exists(level_path):
		print("Level file missing: ", level_path)
		return
		
	var file = FileAccess.open(level_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	if json.parse(content) == OK:
		var data = json.data
		current_level_data = PuzzleLevelData.new()
		current_level_data.level_id = current_level_idx + 1
		current_level_data.difficulty = data.get("difficulty", "Normal")
		current_level_data.board_size = Vector2i(data.get("width", 8), data.get("height", 8))
		current_level_data.starting_lives = data.get("lives", 3)
		current_level_data.pieces = []
		var pid = 1
		for p_dict in data.get("pieces", []):
			var p_data = PuzzlePieceData.create(pid, p_dict.get("cells", []), Vector2i(p_dict.get("direction")[0], p_dict.get("direction")[1]))
			current_level_data.pieces.append(p_data)
			pid += 1
		_build_level_from_resource(current_level_data)

func _build_level_from_resource(lvl: PuzzleLevelData):
	board_bounds = Rect2i(0, 0, lvl.board_size.x, lvl.board_size.y)
	_update_ui()
	
	pieces_remaining = lvl.pieces.size()
	
	var offset_x = -(board_bounds.size.x * grid_size) / 2.0
	var offset_y = -(board_bounds.size.y * grid_size) / 2.0
	pieces_container.position = Vector2(offset_x, offset_y)
	grid_dots.update_grid(board_bounds, grid_size)
	
	if current_level_idx == 0 and not has_node("TutorialOverlay"):
		var overlay = preload("res://scenes/TutorialOverlay.tscn").instantiate()
		add_child(overlay)
		
	for p_data in lvl.pieces:
		var piece = PuzzlePieceScene.instantiate() as PuzzlePiece
		piece.init_from_data(p_data, grid_size)
		piece.piece_tapped.connect(_on_piece_tapped)
		pieces_container.add_child(piece)
		
		for cell in piece.cells:
			occupied[cell] = piece.piece_id

	_update_idle_pulses()

func _update_ui():
	level_label.text = "Level " + str(current_level_idx + 1)
	if mistake_label:
		mistake_label.text = "✖ " + str(mistake_count)
	if hint_badge:
		hint_badge.text = str(hints_left)
		hint_badge.modulate.a = 1.0 if hints_left > 0 else 0.35
		hint_button.modulate.a = 1.0 if hints_left > 0 else 0.5

func _update_idle_pulses():
	for child in pieces_container.get_children():
		if child is PuzzlePiece and not child.removed:
			child.set_idle_pulse(can_escape(child))

func can_escape(piece: Node2D) -> bool:
	for cell in piece.cells:
		var test_cell = cell + piece.direction
		while board_bounds.has_point(test_cell):
			var blocker = occupied.get(test_cell)
			if blocker != null and blocker != piece.piece_id:
				return false
			test_cell += piece.direction
	return true

func _on_piece_tapped(piece: Node2D):
	if piece.removed:
		return
		
	if can_escape(piece):
		AudioManager.play_move_sound()
		piece.removed = true
		for cell in piece.cells:
			occupied.erase(cell)
		
		piece.animate_successful_escape()
		pieces_remaining -= 1
		
		get_tree().create_timer(0.35).timeout.connect(_update_idle_pulses)
		
		if pieces_remaining <= 0:
			AudioManager.play_win_sound()
			_on_level_complete()
	else:
		AudioManager.play_blocked_sound()
		mistake_count += 1
		_update_ui()
		piece.animate_blocked_tap()

func _on_level_complete():
	var elapsed_sec = (Time.get_ticks_msec() - level_start_time_msec) / 1000.0
	
	# Determine star rating
	var stars = 3
	if mistake_count > 2:
		stars = 1
	elif mistake_count > 0:
		stars = 2
		
	var level_key = str(current_level_idx)
	SaveManager.level_stars[level_key] = max(stars, SaveManager.level_stars.get(level_key, 0))
	var prev_best = SaveManager.level_best_times.get(level_key, 99999.0)
	if elapsed_sec < prev_best:
		SaveManager.level_best_times[level_key] = elapsed_sec
	SaveManager.level_mistakes[level_key] = mistake_count
	
	# Spawn subtle celebratory particle confetti
	for i in range(24):
		var cp = ColorRect.new()
		cp.color = COLOR_SUCCESS if i % 2 == 0 else COLOR_ACCENT
		cp.size = Vector2(8, 8)
		cp.position = Vector2(360, 640)
		add_child(cp)
		var t = create_tween().set_parallel(true)
		var angle = randf() * TAU
		var dist = randf_range(150, 600)
		var target = cp.position + Vector2(cos(angle), sin(angle)) * dist
		t.tween_property(cp, "position", target, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		t.tween_property(cp, "modulate:a", 0.0, 0.8)
		t.chain().tween_callback(cp.queue_free)
	
	# Update save
	current_level_idx += 1
	SaveManager.current_level = current_level_idx
	if current_level_idx > SaveManager.max_level_unlocked:
		SaveManager.max_level_unlocked = current_level_idx
	SaveManager.save_game()
	
	# Show Victory Screen result card
	var vs = VictoryScreenScene.instantiate()
	add_child(vs)
	if vs.has_method("show_result_full"):
		vs.show_result_full(stars, current_level_idx, elapsed_sec, mistake_count)
	elif vs.has_method("show_result"):
		vs.show_result(stars, current_level_idx)
		
	vs.next_pressed.connect(func(): vs.queue_free(); _load_current_level())
	vs.replay_pressed.connect(func():
		vs.queue_free()
		current_level_idx -= 1
		SaveManager.current_level = current_level_idx
		_load_current_level()
	)
	vs.levels_pressed.connect(func():
		vs.queue_free()
		get_tree().change_scene_to_file("res://scenes/LevelSelect.tscn")
	)

func _on_restart_pressed():
	AudioManager.play_button_sound()
	_load_current_level()

func _on_hint_pressed():
	if hints_left > 0:
		hints_left -= 1
		SaveManager.hint_count = hints_left
		SaveManager.save_game()
		_update_ui()
		AudioManager.play_button_sound()
		
		for child in pieces_container.get_children():
			if child is PuzzlePiece and not child.removed:
				if can_escape(child):
					var tween = create_tween()
					tween.tween_property(child.line, "default_color", COLOR_ACCENT, 0.2)
					tween.tween_property(child.line, "default_color", COLOR_PRIMARY_TEXT, 0.2)
					tween.set_loops(3)
					break
