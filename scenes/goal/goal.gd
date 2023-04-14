extends Area2D

@export var goal_position: GOAL_POSITION = GOAL_POSITION.LEFT 

@onready var score = get_parent().get_parent().get_node("Score")
@onready var ball = get_parent().get_parent().get_node("Ball")

enum GOAL_POSITION {
	LEFT,
	RIGHT
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if goal_position == GOAL_POSITION.LEFT:
		score.add_one_to_player_left()
	elif goal_position == GOAL_POSITION.RIGHT:
		score.add_one_to_player_right()
	
