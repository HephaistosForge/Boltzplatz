class_name Rod
extends CharacterBody2D

const IMAGE: String = "Sprite2D"
const FOOT_IMAGE: String = "FootSprite"
const UP_PLAYER_LEFT: String = "up_player_left"
const UP_PLAYER_RIGHT: String = "up_player_right"
const DOWN_PLAYER_LEFT: String = "down_player_left"
const DOWN_PLAYER_RIGHT: String = "down_player_right"
const KICK_PLAYER_LEFT: String = "kick_player_left"
const KICK_PLAYER_RIGHT: String = "kick_player_right"

const KICKING_SPEED = 0.1 # Speed of collision shape kicking tween; Smaller is faster
const KICK_FORCE_MULTIPLIER = 80.0

@export var _movement_speed = 500.0
@export var images: Array[CompressedTexture2D]
@export var _player_type: PLAYER_TYPE = PLAYER_TYPE.PLAYER_LEFT 

@onready var ball_kicking_sfx = preload("res://assets/audio/sfx/Kick.mp3")
var figures = []

var input_direction: float = 0.0
var kicking_vector: Vector2 = Vector2(50, 0)

var is_kicking: bool = false
var can_kick: bool = true
var apply_kick_force = false
var power_up_kick_force = 0

enum PLAYER_TYPE {
	PLAYER_LEFT,
	PLAYER_RIGHT
}

func _ready():
	for child in get_children():
		if child is StaticBody2D:
			if _player_type == PLAYER_TYPE.PLAYER_LEFT:
				child.get_node(IMAGE).texture = images[0]
				child.get_node(IMAGE).rotation_degrees = 180
				
			elif _player_type == PLAYER_TYPE.PLAYER_RIGHT:
				child.get_node(IMAGE).texture = images[1]
				child.get_node(FOOT_IMAGE).rotation_degrees = 180
			else:
				printerr("Player type unrecognised: %s" % str(_player_type))
			figures.append(child)
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
		apply_kick_force = true
		can_kick = false
		
		# Kick by moving collision shape
		for figure in figures:
			var tween = create_tween()
			tween.tween_property(figure.get_node("CollisionShape2D"), "position", kicking_vector, KICKING_SPEED)
			tween.parallel().tween_property(figure.get_node(FOOT_IMAGE), "position", kicking_vector, KICKING_SPEED)
			tween.tween_callback(self.disable_kickforce)
			tween.tween_property(figure.get_node("CollisionShape2D"), "position", Vector2.ZERO, KICKING_SPEED)
			tween.parallel().tween_property(figure.get_node(FOOT_IMAGE), "position", Vector2.ZERO, KICKING_SPEED)
		
		can_kick = true
	
	velocity = transform.y * input_direction * _movement_speed
	
	move_and_slide()
	
	for figure in figures:
		var collision_object = figure.move_and_collide(Vector2.ZERO, true)
		if collision_object != null:
			if collision_object.get_collider().is_in_group("Ball"):
				collision_object.get_collider().last_player_touched = _player_type
				var kick_force = kicking_vector
				if apply_kick_force:
					# Fine tuned for slight sound variation
					Global.create_audio_stream_with_random_pitch(ball_kicking_sfx, 0.95, 1.25) 
					kick_force = kick_force * (KICK_FORCE_MULTIPLIER + power_up_kick_force)
				else:
					Global.create_audio_stream_with_random_pitch_and_db(ball_kicking_sfx, 0.95, 1.25, -30)
				collision_object.get_collider().apply_impulse(kick_force)


func disable_kickforce():
	self.apply_kick_force = false


func set_player(player: int) -> void:
	if player == PLAYER_TYPE.PLAYER_LEFT or player == PLAYER_TYPE.PLAYER_RIGHT:
		_player_type = player as PLAYER_TYPE
	else:
		printerr("Invalid player type: %s" % str(_player_type))
