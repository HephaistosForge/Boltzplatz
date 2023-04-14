extends RigidBody2D


@export var _velocity = 1000
@export var timeout_after_reset = 2 # in seconds

var right_down = Vector2(_velocity, _velocity)
var right_up = Vector2(_velocity, -_velocity)
var left_down = Vector2(-_velocity, _velocity)
var left_up = Vector2(-_velocity, -_velocity)

var rotation_offset = 0.02

var has_position_update: bool = false
var is_waiting: bool = false

var _new_position: Vector2


func _ready():
	# var rng = RandomNumberGenerator.new() # Todo?: Choose starting vector randomly
	
	self.gravity_scale = 0 # Disable gravity
	
	set_to_position(get_viewport().get_visible_rect().get_center()) # Initial position reset


func _process(_delta):
	$Sprite2D.rotation += rotation_offset


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
	has_position_update = true


func _start_moving_after_delay() -> void:
	if not is_waiting:
		is_waiting = true
		await get_tree().create_timer(timeout_after_reset).timeout
		self.apply_impulse(left_up)
		is_waiting = false


func set_velocity(new_velocity: int) -> void:
	_velocity = new_velocity
