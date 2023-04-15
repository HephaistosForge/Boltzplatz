extends Node


func _process(_delta):
	if Input.is_action_just_pressed("reset_ball"):
		var ball = get_parent().get_node("Ball")
		ball.set_to_position(get_viewport().get_visible_rect().get_center())
	
	if Input.is_action_just_pressed("change_level_settings"):
		var level_manager = get_parent().get_node("LevelManager")
		level_manager.set_random_level_settings()
