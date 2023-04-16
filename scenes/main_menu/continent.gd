extends Area2D
@onready var default_continent = preload("res://world.tscn")

@export var level_settings = Global.LEVEL_SETTINGS.STREET

func _on_mouse_entered():
	if not get_parent().ball_was_kicked:
		get_tree().get_first_node_in_group("audio_click").play()
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ONE * 1.05, 0.25) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(self, "rotation", .02, 0.25) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(self, "modulate", Color(1, .8, .8), 0.25) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_mouse_exited():
	if not get_parent().ball_was_kicked:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ONE, 0.25) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(self, "rotation", 0, 0.25) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.25) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_input_event(_viewport, event, _shape_idx):
	
	if event is InputEventMouseButton and not get_parent().ball_was_kicked:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT and event.pressed:
			
			get_parent().get_node("AudioWind").play()
			
			var tween = create_tween()
			var ball = get_parent().get_node("Ballface")
			get_parent().ball_was_kicked = true
			var initial_scale = ball.scale
			tween.tween_property(ball, "position", position-ball.pivot_offset+Vector2(.25, .3), .6) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			tween.parallel().tween_property(ball, "scale", initial_scale * .6, .5) \
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
			tween.parallel().tween_property(ball, "rotation", TAU * 2, .5).from_current() \
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
			#tween.tween_property(ball, "scale", initial_scale * .4, .2) \
			#	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			tween.tween_property(ball, "scale", initial_scale * .014, .6) \
				.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
			tween.parallel().tween_property(ball, "rotation", TAU * 4, 1.2).from_current() \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
				
			var continent_tween = create_tween()
			continent_tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			continent_tween.parallel().tween_property(self, "rotation", -.04, 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			continent_tween.parallel().tween_property(self, "modulate", Color(.9, .7, .7), 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
				
			continent_tween.tween_property(self, "scale", Vector2.ONE * 1.4, 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			continent_tween.parallel().tween_property(self, "rotation", .06, 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			continent_tween.parallel().tween_property(self, "modulate", Color(.6, .4, .4), 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
				
			continent_tween.tween_property(self, "scale", Vector2.ONE * 1.6, 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			continent_tween.parallel().tween_property(self, "rotation", -.08, 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			continent_tween.parallel().tween_property(self, "modulate", Color(.3, .1, .1), 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
				
			var field_texture = Global.level_to_texture[level_settings]
			var rect = TextureRect.new()
			rect.texture = field_texture
			rect.modulate = Color(1, 1, 1, 0)
			rect.scale = Vector2.ONE / 32
			get_parent().add_child(rect)
			rect.position = position - rect.size * rect.scale / 2
			continent_tween.parallel().tween_property(rect, "modulate", Color(1, 1, 1), 0.25) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
				
			# var camera_tween = create_tween()
			var camera = get_parent().get_node("Camera2D")
			continent_tween.parallel().tween_property(camera, "zoom", Vector2.ONE / rect.scale.x, 2) \
				.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
			continent_tween.parallel().tween_property(camera, "position", position - camera.offset, 1) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
				
			await continent_tween.finished
			# await continent_tween.finished
			get_tree().change_scene_to_packed(default_continent)
			Global.selected_level_settings = level_settings
