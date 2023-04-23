extends Node

var camera_props_before_change_to_field: Dictionary = {
	"zoom": Vector2.ONE,
	"position": Vector2.ZERO
}

var continent_position = Vector2.ZERO

var has_entered_continent := false

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

@onready var commentary_player = _create_new_audio_stream()

var current_continent = "europe"

var game_finished = false

var commentary_random = [
	preload("res://assets/commentary/random/random01.mp3"),
	preload("res://assets/commentary/random/random02.mp3"),
	preload("res://assets/commentary/random/random03.mp3"),
	preload("res://assets/commentary/random/random04.mp3"),
	preload("res://assets/commentary/random/random05.mp3"),
	preload("res://assets/commentary/random/random06.mp3"),
	preload("res://assets/commentary/random/random07.mp3"),
	preload("res://assets/commentary/random/random08.mp3"),
	preload("res://assets/commentary/random/random09.mp3"),
	preload("res://assets/commentary/random/random10.mp3"),
	preload("res://assets/commentary/random/random11.mp3"),
	preload("res://assets/commentary/random/random12.mp3"),
	preload("res://assets/commentary/random/random13.mp3"),
	preload("res://assets/commentary/random/random14.mp3"),
	preload("res://assets/commentary/random/random15.mp3"),
	preload("res://assets/commentary/random/random16.mp3"),
	preload("res://assets/commentary/random/random17.mp3"),
	preload("res://assets/commentary/random/random18.mp3"),
	preload("res://assets/commentary/random/random19.mp3"),
	preload("res://assets/commentary/random/random20.mp3"),
	preload("res://assets/commentary/random/random21.mp3"),
	preload("res://assets/commentary/random/random22.mp3"),
	preload("res://assets/commentary/random/random23.mp3"),
	preload("res://assets/commentary/random/random24.mp3"),
]

var commentary_goal = [
	preload("res://assets/commentary/tor/tor02.mp3"),
	preload("res://assets/commentary/tor/tor03.mp3"),
	preload("res://assets/commentary/tor/tor04.mp3"),
	preload("res://assets/commentary/tor/tor05.mp3"),
	preload("res://assets/commentary/tor/tor06.mp3"),
	preload("res://assets/commentary/tor/tor07.mp3"),
	preload("res://assets/commentary/tor/tor08.mp3"),
	preload("res://assets/commentary/tor/tor09.mp3"),
	preload("res://assets/commentary/tor/tor10.mp3"),
	preload("res://assets/commentary/tor/tor11.mp3"),
	preload("res://assets/commentary/tor/tor12.mp3"),
	preload("res://assets/commentary/tor/tor13.mp3"),
	preload("res://assets/commentary/tor/tor14.mp3"),
	preload("res://assets/commentary/tor/tor15.mp3"),
	preload("res://assets/commentary/tor/tor16.mp3"),
]

var commentary_close = [
	preload("res://assets/commentary/close/daneben01.mp3"),
	preload("res://assets/commentary/close/daneben02.mp3"),
	preload("res://assets/commentary/close/daneben03.mp3"),
	preload("res://assets/commentary/close/daneben04.mp3"),
	preload("res://assets/commentary/close/daneben05.mp3"),
	preload("res://assets/commentary/close/daneben06.mp3"),
	preload("res://assets/commentary/close/daneben07.mp3"),
	preload("res://assets/commentary/close/daneben08.mp3"),
	preload("res://assets/commentary/close/daneben09.mp3"),
	preload("res://assets/commentary/close/daneben10.mp3"),
	preload("res://assets/commentary/close/daneben11.mp3"),
	preload("res://assets/commentary/close/daneben12.mp3"),
	preload("res://assets/commentary/close/daneben13.mp3"),
	preload("res://assets/commentary/close/daneben14.mp3"),
	preload("res://assets/commentary/close/daneben15.mp3"),
	preload("res://assets/commentary/close/daneben16.mp3"),
]

var commentary_pregame = {
	"north_america": preload("res://assets/commentary/opening/usa.mp3"),
	"antarctica": preload("res://assets/commentary/opening/antarktis.mp3"),
	"australia": preload("res://assets/commentary/opening/australien.mp3"),
	"south_america": preload("res://assets/commentary/opening/südamerika.mp3"),
	"asia": preload("res://assets/commentary/opening/asien.mp3"),
	"europe": preload("res://assets/commentary/opening/europa.mp3"),
	"africa": preload("res://assets/commentary/opening/afrika.mp3"),
}

func _ready():
	Signals.level_entry_animation_finished.connect(_on_level_entry_animation_finished)


func _on_level_entry_animation_finished() -> void:
	has_entered_continent = true


func play_commentary_random():
	return play_random_from_list(commentary_random)
	
func play_commentary_goal():
	return play_random_from_list(commentary_goal)
	
func play_commentary_close():
	return play_random_from_list(commentary_close)
	
func play_commentary_pregame():
	if current_continent in commentary_pregame:
		return create_audio_stream(commentary_pregame[current_continent], commentary_player)
	return null
	
func play_random_from_list(list):
	if len(list) == 0:
		return null
	var audio = list[randi_range(0, len(list)-1)]
	return create_audio_stream(audio, commentary_player)


var selected_level_settings: LEVEL_SETTINGS


func _create_playfield_texture() -> TextureRect:
	var field_texture = self.level_to_texture[self.selected_level_settings]
	var rect = TextureRect.new()
	rect.texture = field_texture
	rect.scale = Vector2.ONE / 32
	get_parent().add_child(rect)
	
	return rect


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
	sfx.add_to_group("sfx")
	return sfx
	
