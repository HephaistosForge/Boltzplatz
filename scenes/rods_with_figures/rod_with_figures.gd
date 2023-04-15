extends CharacterBody2D

const IMAGE: String = "Sprite2D"
const UP_PLAYER_LEFT: String = "up_player_left"
const UP_PLAYER_RIGHT: String = "up_player_right"
const DOWN_PLAYER_LEFT: String = "down_player_left"
const DOWN_PLAYER_RIGHT: String = "down_player_right"
const KICK_PLAYER_LEFT: String = "kick_player_left"
const KICK_PLAYER_RIGHT: String = "kick_player_right"

const KICKING_SPEED = 0.05 # Speed of collision shape kicking tween; Smaller is faster

@export var _movement_speed = 500.0
@export var images: Array[CompressedTexture2D]
@export var _player_type: PLAYER_TYPE = PLAYER_TYPE.PLAYER_LEFT 

var input_direction: float = 0.0
var kicking_vector: Vector2 = Vector2(50, 0)

var is_kicking: bool = false
var can_kick: bool = true

enum PLAYER_TYPE {
	PLAYER_LEFT,
	PLAYER_RIGHT
}

func _ready():
	for child in get_children():
		if child is CharacterBody2D:
			if _player_type == PLAYER_TYPE.PLAYER_LEFT:
				child.get_node(IMAGE).texture = images[0]
				child.get_node(IMAGE).rotation_degrees = 180
			elif _player_type == PLAYER_TYPE.PLAYER_RIGHT:
				child.get_node(IMAGE).texture = images[1]
			else:
				printerr("Player type unrecognised: %s" % str(_player_type))
	
	if _player_type == PLAYER_TYPE.PLAYER_RIGHT:
		kicking_vector *= -1 # Kick to the left


func _physics_process(_delta):
	if _player_type == PLAYER_TYPE.PLAYER_LEFT:
		input_direction = Input.get_axis(UP_PLAYER_LEFT, DOWN_PLAYER_LEFT)
		is_kicking = Input.is_action_just_pressed(KICK_PLAYER_LEFT)
	elif _player_type == PLAYER_TYPE.PLAYER_RIGHT:
		input_direction = Input.get_axis(UP_PLAYER_RIGHT, DOWN_PLAYER_RIGHT)
		is_kicking = Input.is_action_just_pressed(KICK_PLAYER_RIGHT)
	else:
		printerr("Player type unrecognised: %s" % str(_player_type))
	
	if can_kick and is_kicking:
		can_kick = false
		
		# Kick by moving collision shape
		for child in get_children():
			if child is CharacterBody2D:
				var tween = create_tween()
				tween.tween_property(child.get_node("CollisionShape2D"), "position", kicking_vector, KICKING_SPEED)
				tween.tween_property(child.get_node("CollisionShape2D"), "position", Vector2.ZERO, KICKING_SPEED)
		
		$SFXKick.play_with_random_pitch()
		
		can_kick = true
	
	velocity = transform.y * input_direction * _movement_speed
	
	move_and_slide()


func set_player(player: int) -> void:
	if player == PLAYER_TYPE.PLAYER_LEFT or player == PLAYER_TYPE.PLAYER_RIGHT:
		_player_type = player as PLAYER_TYPE
	else:
		printerr("Invalid player type: %s" % str(_player_type))
