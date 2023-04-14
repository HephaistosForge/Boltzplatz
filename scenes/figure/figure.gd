extends CharacterBody2D

class_name Figure

const UP_PLAYER_LEFT: String = "up_player_left"
const UP_PLAYER_RIGHT: String = "up_player_right"
const DOWN_PLAYER_LEFT: String = "down_player_left"
const DOWN_PLAYER_RIGHT: String = "down_player_right"

@export var _movement_speed = 500.0
@export var images: Array[CompressedTexture2D]

var _player = PLAYER_LEFT
var input_direction: float = 0.0

enum {
	PLAYER_LEFT,
	PLAYER_RIGHT
}

func _ready():
	if _player == PLAYER_LEFT:
		$Sprite2D.texture = images[0]
		$Sprite2D.rotation_degrees = 180
	elif _player == PLAYER_RIGHT:
		$Sprite2D.texture = images[1]
	else:
		printerr("Player type unrecognised: %s" % str(_player))


func _physics_process(_delta):
	if _player == PLAYER_LEFT:
		input_direction = Input.get_axis(UP_PLAYER_LEFT, DOWN_PLAYER_LEFT)
	elif _player == PLAYER_RIGHT:
		input_direction = Input.get_axis(UP_PLAYER_RIGHT, DOWN_PLAYER_RIGHT)
	else:
		printerr("Player type unrecognised: %s" % str(_player))
	
	velocity = transform.y * input_direction * _movement_speed
	
	move_and_slide()


func set_player(player: int) -> void:
	if player == PLAYER_LEFT or player == PLAYER_RIGHT:
		_player = player
	else:
		printerr("Invalid player type: %s" % str(_player))
