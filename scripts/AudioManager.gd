extends Node

var stream_player: AudioStreamPlayer

func _ready():
	stream_player = AudioStreamPlayer.new()
	add_child(stream_player)

func play_move_sound():
	_play_synth_notes([523.25, 659.25], 0.12, 0.15) # C5, E5 soft chime

func play_blocked_sound():
	_play_synth_notes([180.0, 140.0], 0.18, 0.25) # Soft low thud

func play_win_sound():
	_play_synth_notes([523.25, 659.25, 783.99, 1046.50], 0.35, 0.2) # C Major arpeggio

func play_button_sound():
	_play_synth_notes([800.0], 0.04, 0.08) # Gentle UI click

func _play_synth_notes(freqs: Array, duration: float, volume: float):
	var sample_rate = 44100
	var num_frames = int(sample_rate * duration)
	var stream = AudioStreamGenerator.new()
	stream.mix_rate = sample_rate
	stream.buffer_length = duration + 0.05
	
	stream_player.stream = stream
	stream_player.volume_db = linear_to_db(volume)
	stream_player.play()
	
	var playback = stream_player.get_stream_playback()
	if not playback:
		return
		
	var frames = PackedVector2Array()
	var note_len = num_frames / freqs.size()
	
	for n_idx in range(freqs.size()):
		var freq: float = freqs[n_idx]
		var phase = 0.0
		var increment = freq / sample_rate
		for i in range(note_len):
			var sample = sin(phase * TAU)
			var env = 1.0 - (float(i) / note_len)
			frames.append(Vector2(sample * env, sample * env))
			phase = fmod(phase + increment, 1.0)
			
	playback.push_buffer(frames)
