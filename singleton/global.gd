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

@export var level_to_texture = {
	LEVEL_SETTINGS.DEFAULT: preload("res://assets/backgrounds/Spielfeld_grass_stripes.png"),
	LEVEL_SETTINGS.DEFAULT2: preload("res://assets/backgrounds/Spielfeld_grass_stripes2.png"),
	LEVEL_SETTINGS.DEFAULT_NO_GOAL: preload("res://assets/backgrounds/Spielfeld_ohne_Tor.png"),
	LEVEL_SETTINGS.STREET: preload("res://assets/backgrounds/Spielfeld_street.png"),
	LEVEL_SETTINGS.MUD: preload("res://assets/backgrounds/Spielfeld_mud.png"),
	LEVEL_SETTINGS.ICE: preload("res://assets/backgrounds/Spielfeld_ice.png"),
	LEVEL_SETTINGS.SAND: preload("res://assets/backgrounds/Spielfeld_sand.png"),
}


var commentary_random = [
	#preload()
]

var commentary_goal = [
	#preload()
]

var commentary_close = [
	#preload()
]

var commentary_pregame = [
	#preload()
]

func play_commentary_random():
	return play_random_from_list(commentary_random)
	
func play_commentary_goal():
	return play_random_from_list(commentary_goal)
	
func play_commentary_close():
	return play_random_from_list(commentary_goal)
	
func play_commentary_pregame():
	return play_random_from_list(commentary_goal)
	
func play_random_from_list(list):
	if len(list) == 0:
		return null
	var audio = list[randi_range(0, len(list)-1)]
	return create_audio_stream(audio)


var selected_level_settings: LEVEL_SETTINGS


func create_audio_stream_with_random_pitch(stream: AudioStream, upper_limit: float, lower_limit: float) -> void:
	var sfx = _create_new_audio_stream()
	sfx.pitch_scale = randf_range(upper_limit, lower_limit) # Fine tuned for slight sound variation
	create_audio_stream(stream, sfx)


func create_audito_stream_with_custom_db(stream: AudioStream, db) -> void:
	var sfx = _create_new_audio_stream()
	sfx.volume_db = db
	create_audio_stream(stream, sfx)

func create_audio_stream_with_random_pitch_and_db(stream: AudioStream, upper_limit: float, lower_limit: float, db) -> void:
	var sfx = _create_new_audio_stream()
	sfx.volume_db = db
	sfx.pitch_scale = randf_range(upper_limit, lower_limit)
	create_audio_stream(stream, sfx)


func create_audio_stream(stream: AudioStream, sfx: AudioStreamPlayer2D=_create_new_audio_stream()):
	sfx.stream = stream
	sfx.play()
	return sfx


func _create_new_audio_stream() -> AudioStreamPlayer2D:
	var sfx = AudioStreamPlayer2D.new()
	add_child(sfx)
	return sfx
	
