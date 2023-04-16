extends Control

@onready var initial_scale = scale
@onready var initial_rotation = rotation

@export var time = 0.25
@export var scale_multiplier = Vector2.ONE * 1.1
@export var target_angle = 2 * PI
@export var target_color = Color(.8, .8, .8)



func _on_mouse_entered():
	if not get_parent().ball_was_kicked:
		get_tree().get_first_node_in_group("audio_click").play()
		var tween = create_tween()
		tween.tween_property(self, "scale", initial_scale * scale_multiplier, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.parallel().tween_property(self, "rotation", target_angle, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.parallel().tween_property(self, "modulate", target_color, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)


func _on_mouse_exited():
	if not get_parent().ball_was_kicked:
		var tween = create_tween()
		tween.tween_property(self, "scale", initial_scale, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(self, "rotation", initial_rotation, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
		tween.parallel().tween_property(self, "modulate", Color.WHITE, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
