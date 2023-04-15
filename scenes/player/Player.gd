extends Node

var rods = []

var kick_power_timer
var reduce_size_timer

var player_type
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is CharacterBody2D:
			rods.append(child)
	player_type = rods[0]._player_type


func add_point():
	match player_type:
		Rod.PLAYER_TYPE.PLAYER_LEFT:
			pass
		Rod.PLAYER_TYPE.PLAYER_RIGHT:
			pass


func remove_point():
	match player_type:
		Rod.PLAYER_TYPE.PLAYER_LEFT:
			pass
		Rod.PLAYER_TYPE.PLAYER_RIGHT:
			pass


func reduce_size(time):
	if not reduce_size_timer:
		reduce_size_timer = Timer.new()
		self.add_child(reduce_size_timer)
		reduce_size_timer.start(time)
		reduce_size_timer.connect("on_timer_timeout", _on_reduce_size_timer_timeout)
	
		for rod in rods:
			for figure in rod.figures:
				var tween = create_tween()
				tween.tween_property(figure, "scale", Vector2(1.5, 1.5), 0.2)
	else:
		reduce_size_timer.wait_time = reduce_size_timer.time_left + time


func _on_reduce_size_timer_timeout():
	reduce_size_timer.queue_free()
	for rod in rods:
		for figure in rod.figures:
			var tween = create_tween()
			tween.tween_property(figure, "scale", Vector2(1.0, 1.0), 0.2)


func increase_own_kick_power(time):
	if not kick_power_timer:
		kick_power_timer = Timer.new()
		self.add_child(kick_power_timer)
		kick_power_timer.start(time)
		kick_power_timer.connect("on_timer_timeout", _on_increase_own_kick_power_timeout)
	
		for rod in rods:
			rod.power_up_kick_force = 50
	else:
		kick_power_timer.wait_time = kick_power_timer.time_left + time


func _on_increase_own_kick_power_timeout():
	kick_power_timer.queue_free()
	for rod in rods:
		rod.power_up_kick_force = 0