extends Area2D
var tween
@onready var default_continent = preload("res://world.tscn")
@onready var initial_sprite_position = $AnimatedSprite2D.position

func _on_mouse_entered():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($".","scale", Vector2(1.05,1.05), 0.5)
	tween.parallel().tween_property($AnimatedSprite2D, "position", initial_sprite_position+Vector2(0,-40), 0.5)


func _on_mouse_exited():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($".","scale", Vector2(1.0,1.0), 0.5)
	tween.parallel().tween_property($AnimatedSprite2D, "position", initial_sprite_position, 0.5)


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT and event.pressed:
			get_tree().change_scene_to_packed(default_continent)
			Global.selected_level_settings = Global.LEVEL_SETTINGS.ICE
