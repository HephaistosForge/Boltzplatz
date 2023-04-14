extends RigidBody2D

@export var _velocity = 500

var rotation_offset = 0.02

var right_down = Vector2(_velocity, _velocity)
var right_up = Vector2(_velocity, -_velocity)
var left_down = Vector2(-_velocity, _velocity)
var left_up = Vector2(-_velocity, -_velocity)

var rng


func _ready():
	rng = RandomNumberGenerator.new() # Todo: Choose starting vector randomly
	
	self.gravity_scale = 0 # Disable gravity
	
	self.apply_impulse(left_up)
	
func _process(delta):
	$Sprite2D.rotation += rotation_offset
