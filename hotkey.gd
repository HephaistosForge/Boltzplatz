extends Node

func _process(_delta):
	if Input.is_action_just_pressed("reset_ball"):
		var ball = get_parent().get_node("Ball")
		ball.set_to_position(get_viewport().get_visible_rect().get_center())
	
	if Input.is_action_just_pressed("change_level_settings"):
		var level_manager = get_parent().get_node("LevelManager")
		level_manager.set_random_level_settings()

	if Input.is_action_just_pressed("exit"):
		stop__all_sfx()
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func stop__all_sfx():
	var sfx_nodes = get_tree().get_nodes_in_group("sfx")
	for sfx in sfx_nodes:
		sfx.stop()
