extends Area2D
@onready var default_continent = preload("res://world.tscn")

@export var level_settings = Global.LEVEL_SETTINGS.STREET

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 1.05, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "rotation", .02, 0.25) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(self, "modulate", Color(.8, .8, .8), 0.25) \
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
			get_tree().change_scene_to_packed(default_continent)
			Global.selected_level_settings = level_settings
