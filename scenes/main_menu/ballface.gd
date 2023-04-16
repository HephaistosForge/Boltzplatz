extends TextureRect

@onready var initial_scale = scale

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "scale", initial_scale * 1.2, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(self, "rotation", 2*PI, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.parallel().tween_property(self, "modulate", Color(.8, .8, .8), 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)


func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", initial_scale, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "rotation", 0, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
