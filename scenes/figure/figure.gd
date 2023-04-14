extends CharacterBody2D

const UP_PLAYER_ONE: String = "up_player_one"
const UP_PLAYER_TWO: String = "up_player_two"
const DOWN_PLAYER_ONE: String = "down_player_one"
const DOWN_PLAYER_TWO: String = "down_player_two"
const PLAYER_ONE: int = 1
const PLAYER_TWO: int = 2

@export var movement_speed = 500.0
@export var player = PLAYER_ONE # 1 = player one, 2 = player two

var input_direction: float = 0.0


func _ready():
	pass


func _physics_process(_delta):
	if player == PLAYER_ONE:
		input_direction = Input.get_axis(UP_PLAYER_ONE, DOWN_PLAYER_ONE)
	else:
		input_direction = Input.get_axis(UP_PLAYER_TWO, DOWN_PLAYER_TWO)
	
	velocity = transform.y * input_direction * movement_speed
	
	move_and_slide()
