extends CharacterBody2D

class_name Figure

const UP_PLAYER_ONE: String = "up_player_one"
const UP_PLAYER_TWO: String = "up_player_two"
const DOWN_PLAYER_ONE: String = "down_player_one"
const DOWN_PLAYER_TWO: String = "down_player_two"

@export var _movement_speed = 500.0
@export var images: Array[ImageTexture]

var _player = 1 # 1 = Player One, 2 = Player Two
var input_direction: float = 0.0


func _ready():
	if _player == 1:
		$Sprite2D.texture = images[0]
	else:
		$Sprite2D.texture = images[1]


func _physics_process(_delta):
	if _player == 1:
		input_direction = Input.get_axis(UP_PLAYER_ONE, DOWN_PLAYER_ONE)
	else:
		input_direction = Input.get_axis(UP_PLAYER_TWO, DOWN_PLAYER_TWO)
	
	velocity = transform.y * input_direction * _movement_speed
	
	move_and_slide()


func set_player(player: int) -> void:
	_player = player
