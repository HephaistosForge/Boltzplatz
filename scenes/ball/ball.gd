extends RigidBody2D

@onready var ball_kicking_sfx = preload("res://assets/audio/sfx/Kick.mp3")
@onready var bounce_particles = preload("res://scenes/particles/ball_bounce.tscn")

@onready var initial_sprite_scale = $Sprite2D.scale

@export var _velocity = 1000
@export var timeout_after_reset = 2 # in seconds

var direction: Vector2
var direction_as_angle: float

var first_ball = true

var rotation_offset = 0.02

var has_position_update: bool = false
var is_waiting: bool = false

var _new_position: Vector2
var center: Vector2
var acceleration = Vector2.ZERO

var last_player_touched = Rod.PLAYER_TYPE.PLAYER_LEFT

var game_over = false

func _ready():
	self.gravity_scale = 0 # Disable gravity
	
	center = get_viewport().get_visible_rect().get_center()
	set_to_position(center) # Initial position reset


func _integrate_forces(state):
	if game_over:
		state.linear_velocity = Vector2.ZERO
		return
	
	if state.get_contact_count() > 0:
		var normal: Vector2 = state.get_contact_local_normal(0)
		var angle: float = normal.angle()

		apply_particles(normal, angle)
		play_kick_sound()
		apply_deformation()
	
	if has_position_update:
		update_position(state)
	
	limit_velocity(state)


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


func apply_particles(normal: Vector2, angle: float):
	var particles = bounce_particles.instantiate()
	particles.position = position - normal * 25 # global_position + pos.normalized() * 10
	particles.rotation = angle # global_position.angle_to_point(body.global_position)
	get_parent().add_child(particles)
	particles.emitting = true
	get_tree().create_timer(1).connect("timeout", particles.queue_free)
		
		
func apply_deformation():
	var tween = create_tween()
	var time = .1
	tween.tween_property($Sprite2D, "scale", initial_sprite_scale * Vector2(1.1, 0.9), time) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "scale", initial_sprite_scale * Vector2(0.95, 1.05), time) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "scale", initial_sprite_scale, time) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)


func play_kick_sound():
	Global.create_audio_stream_with_random_pitch(ball_kicking_sfx, 0.95, 1.25) 


func update_position(state):
	has_position_update = false
	state.transform.origin = _new_position
	_start_moving_after_delay()
	

func limit_velocity(state):
	# Limit min / max speed
	if state.linear_velocity.length() != _velocity:
		state.linear_velocity = state.linear_velocity.normalized() * _velocity


func _input(event):
	if event.is_action_pressed("skip_dialog"):
		Global.commentary_player.stop()
		Global.commentary_player.emit_signal("finished")
		

func _start_moving_after_delay() -> void:
	if first_ball:
		Global.play_commentary_pregame()
		first_ball = false
		
	if not is_waiting:
		is_waiting = true
		choose_random_movement_direction()
		show_direction_tween()
		
		await get_tree().create_timer(timeout_after_reset).timeout
		
		start_ball_movement()
		is_waiting = false


func choose_random_movement_direction() -> void:
	var angle = randf_range(-PI / 4, PI / 4)
	var possibly_flipped = angle + (PI if randf() < 0.5 else 0.0)
	direction = Vector2(cos(possibly_flipped), sin(possibly_flipped)) * _velocity
	direction_as_angle = possibly_flipped


func show_direction_tween():
	var overturn_angle = direction_as_angle + TAU/4 + TAU * 5
	$Pointer.scale = Vector2.ONE
	var tween = create_tween()
	tween.tween_property($Pointer, "global_rotation", overturn_angle, 1.8) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property($Pointer, "scale", Vector2.ONE * 1.2, 1.8) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Pointer, "scale", Vector2.ONE * .1, 1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		

func start_ball_movement():
	self.acceleration = direction.normalized()
	self.apply_impulse(direction)
	apply_torque_impulse(0.01)


func set_velocity(new_velocity: int) -> void:
	_velocity = new_velocity


func _on_visible_on_screen_notifier_2d_screen_exited():
	# Ball is outside visible area
	if not game_over:
		set_to_position(center)


func _on_score_game_is_over():
	game_over = true
	get_tree().paused = true

	
