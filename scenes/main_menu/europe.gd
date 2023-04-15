extends Area2D
var tween
@onready var default_continent = preload("res://world.tscn")

func _on_mouse_entered():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($"../north_america","scale", Vector2(1.2,1.2), 0.5)


func _on_mouse_exited():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($"../north_america","scale", Vector2(1.0,1.0), 0.5)


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT and event.pressed:
			get_tree().change_scene_to_packed(default_continent)
			Global.selected_level_settings = Global.LEVEL_SETTINGS.SAND
