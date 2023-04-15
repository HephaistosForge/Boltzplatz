extends RigidBody2D


@export var _velocity = 1000
@export var timeout_after_reset = 2 # in seconds

@onready var directions: Array[Vector2] = [right_down, right_up, left_down, left_up]

var right_down = Vector2(_velocity, _velocity)
var right_up = Vector2(_velocity, -_velocity)
var left_down = Vector2(-_velocity, _velocity)
var left_up = Vector2(-_velocity, -_velocity)

var direction: Vector2

var rotation_offset = 0.02

var has_position_update: bool = false
var is_waiting: bool = false

var _new_position: Vector2
var center: Vector2


func _ready():
	choose_random_movement_direction()
	
	self.gravity_scale = 0 # Disable gravity
	
	center = get_viewport().get_visible_rect().get_center()
	
	set_to_position(center) # Initial position reset
	apply_torque_impulse(0.01)


func _process(_delta):
	#$Sprite2D.rotation += rotation_offset
	pass

func choose_random_movement_direction() -> void:
	var random_index: int = randi_range(0, directions.size() - 1)
	direction = directions[random_index]


func _integrate_forces(state):
	if has_position_update:
		has_position_update = false
		state.transform.origin = _new_position
		_start_moving_after_delay()
	
	# Limit min / max speed
	if state.linear_velocity.length() != _velocity:
		state.linear_velocity = state.linear_velocity.normalized() * _velocity


func set_to_position(new_position: Vector2) -> void:
	self.linear_velocity = Vector2.ZERO
	self.angular_velocity = 0
	
	_new_position = new_position
	
	_adjust_position()
	
	has_position_update = true


func _adjust_position() -> void:
	# Background is not centered perfectly, adjust position
	_new_position.x += 7.5
	_new_position.y += 20


func _start_moving_after_delay() -> void:
	if not is_waiting:
		is_waiting = true
		await get_tree().create_timer(timeout_after_reset).timeout
		
		choose_random_movement_direction()
		self.apply_impulse(direction)
		
		is_waiting = false


func set_velocity(new_velocity: int) -> void:
	_velocity = new_velocity


func _on_visible_on_screen_notifier_2d_screen_exited():
	# Ball is outside visible area
	set_to_position(center)
