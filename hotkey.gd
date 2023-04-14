extends Node


func _process(_delta):
	if Input.is_action_just_pressed("space"):
		var ball = get_parent().get_node("Ball")
		
		ball.set_to_position(get_viewport().get_visible_rect().get_center())