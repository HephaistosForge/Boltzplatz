extends Area2D

@export var goal_position: GOAL_POSITION = GOAL_POSITION.LEFT 

@onready var score = get_parent().get_parent().get_node("Score")
@onready var ball = get_parent().get_parent().get_node("Ball")
@onready var goal_scoring_sfx = preload("res://assets/audio/sfx/GoalScoring.mp3")

enum GOAL_POSITION {
	LEFT,
	RIGHT
}


func _on_body_entered(_body):
	
	print_debug(_body)
			
	if not ball.game_over:
		ball.set_to_position(get_viewport().get_visible_rect().get_center())
		Global.play_commentary_goal()
	
	if goal_position == GOAL_POSITION.LEFT:
		score.add_one_to_player_right()
	elif goal_position == GOAL_POSITION.RIGHT:
		score.add_one_to_player_left()
	
	Global.create_audio_stream(goal_scoring_sfx)

