extends Node

var stream_player: AudioStreamPlayer

func _ready() -> void:
	stream_player = AudioStreamPlayer.new()
	stream_player.bus = "Master"
	add_child(stream_player)

func play_move_sound() -> void:
	_play_synth_notes([523.25, 659.25], 0.12, 0.15)

func play_blocked_sound() -> void:
	_play_synth_notes([180.0, 140.0], 0.18, 0.25)

func play_win_sound() -> void:
	_play_synth_notes([523.25, 659.25, 783.99, 1046.50], 0.35, 0.2)

func play_button_sound() -> void:
	_play_synth_notes([800.0], 0.04, 0.08)

func _play_synth_notes(freqs: Array, duration: float, volume: float) -> void:
	if not SettingsManager.sound_enabled or freqs.is_empty():
		return

	var sample_rate := 44100
	var num_frames := int(sample_rate * duration)
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = sample_rate
	stream.buffer_length = duration + 0.05

	stream_player.stream = stream
	stream_player.volume_db = linear_to_db(volume)
	stream_player.play()

	var playback := stream_player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback == null:
		return

	var frames := PackedVector2Array()
	var note_length := maxi(num_frames / freqs.size(), 1)

	for note_index in range(freqs.size()):
		var frequency := float(freqs[note_index])
		var phase := 0.0
		var increment := frequency / float(sample_rate)
		for frame_index in range(note_length):
			var sample := sin(phase * TAU)
			var envelope := 1.0 - (float(frame_index) / float(note_length))
			frames.append(Vector2(sample * envelope, sample * envelope))
			phase = fmod(phase + increment, 1.0)

	playback.push_buffer(frames)
