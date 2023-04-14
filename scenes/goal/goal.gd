extends Area2D

@export var goal_position: GOAL_POSITION = GOAL_POSITION.LEFT 

@onready var score = get_parent().get_parent().get_node("Score")
@onready var ball = get_parent().get_parent().get_node("Ball")

enum GOAL_POSITION {
	LEFT,
	RIGHT
}


func _on_body_entered(_body):
	if goal_position == GOAL_POSITION.LEFT:
		score.add_one_to_player_right()
	elif goal_position == GOAL_POSITION.RIGHT:
		score.add_one_to_player_left()
		
	ball.set_to_position(get_viewport().get_visible_rect().get_center())
