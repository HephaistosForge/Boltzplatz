extends Control

const default_continent = preload("res://world.tscn")

@export var FADE_OUT_ANIMATION_DURATION = .25

var ball_was_kicked = false


func _ready():
	if Global.has_entered_continent:
		_play_return_to_menu_tween()
		Global.has_entered_continent = false


func _play_return_to_menu_tween() -> void:
	var camera: Camera2D = $Camera2D
	camera.zoom = Global.camera_props_before_change_to_field["zoom"]
	camera.position = Global.camera_props_before_change_to_field["position"]
	
	# Get continent that was previously played on
	var continent
	for child in get_children():
		if child.name == Global.current_continent:
			continent = child
			continue
	
	continent.modulate = Color(.3, .1, .1)
	
	# Playfield fade out
	var playfield_fade_tween = create_tween()
	var rect = Global._create_playfield_texture()
	rect.position = Global.continent_position - rect.size * rect.scale / 2
	var fade_playfield = playfield_fade_tween.parallel().tween_property(rect, "modulate", Color(1.0, 1.0, 1.0, 0.0), FADE_OUT_ANIMATION_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	# Fade modulate of continent that was previously played on
	playfield_fade_tween.parallel().tween_property(continent, "modulate", Color(.6, .4, .4), FADE_OUT_ANIMATION_DURATION) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	playfield_fade_tween.parallel().tween_property(continent, "modulate", Color(.9, .7, .7), FADE_OUT_ANIMATION_DURATION) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	playfield_fade_tween.parallel().tween_property(continent, "modulate", Color(1.0, 1.0, 1.0), FADE_OUT_ANIMATION_DURATION) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	
	playfield_fade_tween.tween_property(camera, "zoom", Vector2.ONE, FADE_OUT_ANIMATION_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	var last_animation = playfield_fade_tween.parallel().tween_property(camera, "position", Vector2(0, 0), FADE_OUT_ANIMATION_DURATION) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
	# Remove now invisible playfield
	await last_animation.finished
	rect.queue_free()
	
	Signals.emit_signal("level_exit_animation_finished")
