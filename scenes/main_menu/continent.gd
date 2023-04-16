extends Area2D
@onready var default_continent = preload("res://world.tscn")

@export var level_settings = Global.LEVEL_SETTINGS.STREET

func _on_mouse_entered():
	get_tree().get_first_node_in_group("audio_click").play()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.05, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "rotation", .02, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "modulate", Color(1, .8, .8), 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "rotation", 0, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_input_event(_viewport, event, _shape_idx):
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT and event.pressed:
			var tween = create_tween()
			var ball = get_parent().get_node("Ballface")
			ball.was_kicked = true
			var initial_scale = ball.scale
			tween.tween_property(ball, "position", position-ball.pivot_offset, .6) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			tween.parallel().tween_property(ball, "scale", initial_scale * .3, .5) \
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
			tween.tween_property(ball, "scale", initial_scale * .4, .2) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			tween.tween_property(ball, "scale", initial_scale * .2, .1) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
			await tween.finished
			get_tree().change_scene_to_packed(default_continent)
			Global.selected_level_settings = level_settings
