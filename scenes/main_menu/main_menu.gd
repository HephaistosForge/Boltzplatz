extends Control

const default_continent = preload("res://world.tscn")

var ball_was_kicked = false


func _ready():
	if Global.has_entered_continent:
		_play_return_to_menu_tween()
		Global.has_entered_continent = false


func _play_return_to_menu_tween() -> void:
	var camera: Camera2D = $Camera2D
	camera.zoom = Global.camera_props_before_change_to_field["zoom"]
	camera.position = Global.camera_props_before_change_to_field["position"]
	
	var reverse_tween = create_tween()
	reverse_tween.tween_property(camera, "zoom", Vector2.ONE, .5) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	reverse_tween.parallel().tween_property(camera, "position", Vector2(0, 0), .5) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
	# Fade modulate of continent that was previously played on
	for child in get_children():
		if child.name == Global.current_continent:
			child.modulate = Color(.3, .1, .1)
			reverse_tween.parallel().tween_property(child, "modulate", Color(.6, .4, .4), .25) \
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
			reverse_tween.parallel().tween_property(child, "modulate", Color(.9, .7, .7), .25) \
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
			reverse_tween.parallel().tween_property(child, "modulate", Color(1.0, 1.0, 1.0), .25) \
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
			
			continue
