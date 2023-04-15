extends Node

enum LEVEL_SETTINGS {
	DEFAULT,
	DEFAULT2,
	DEFAULT_NO_GOAL,
	STREET,
	MUD,
	ICE,
	SAND
}

var selected_level_settings: LEVEL_SETTINGS


func create_audio_stream_with_random_pitch(stream: AudioStream, upper_limit: float, lower_limit: float) -> void:
	var sfx = _create_new_audio_stream()
	sfx.pitch_scale = randf_range(upper_limit, lower_limit) # Fine tuned for slight sound variation
	create_audio_stream(stream)


func create_audio_stream(stream: AudioStream) -> void:
	var sfx = _create_new_audio_stream()
	sfx.stream = stream
	sfx.play()


func _create_new_audio_stream() -> AudioStreamPlayer2D:
	var sfx = AudioStreamPlayer2D.new()
	add_child(sfx)
	return sfx
