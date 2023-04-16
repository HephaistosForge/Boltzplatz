extends StaticBody2D

const POWER_UP_PREFAB = preload("res://scenes/powerup/power_up.tscn")
const DESCRIPTION_PREFAB = preload("res://scenes/powerup/description.tscn")

var power_up
var touched_by

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * .3, 1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


func _physics_process(_delta: float) -> void:
	var collision_object = move_and_collide(Vector2.ZERO, true)
	if collision_object != null:
		if collision_object.get_collider().is_in_group("Ball"):
			touched_by = collision_object.get_collider().last_player_touched
			$CollisionShape2D.disabled = true
			# print(touched_by)
			destroy_box()


func destroy_box():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1.2, .8), 0.1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "scale", Vector2(.8, 1.2), 0.1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "position", Vector2(0, -200), 0.2) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_callback(spawn_power_up)
	tween.tween_property($Sprite2D, "scale", Vector2.ONE * 1.4, 0.2) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0.2) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	#tween.tween_property($Sprite2D, "modulate", Color(Color.WHITE, 0), 0.5)



func spawn_power_up():
	power_up = POWER_UP_PREFAB.instantiate()
	power_up.variant = randi_range(0,3)
	self.add_child(power_up)
	#if tween:
	#	tween.kill()
	var tween = create_tween()
	power_up.scale = Vector2.ZERO
	power_up.modulate = Color.WHITE
	power_up.position = Vector2(0, -200)
	#tween.tween_property(power_up, "modulate", Color(Color.WHITE, 1), 0.3) \
	#	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(power_up, "scale", Vector2(1, 1), 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		
	if touched_by != null:
		var is_left = Rod.PLAYER_TYPE.PLAYER_LEFT == touched_by
		var color = Color.BLUE if is_left else Color.RED
		var pos = Vector2(300 if is_left else 1920 - 300, 1080 / 2)
		tween.tween_property(power_up, "scale", Vector2(1.2, 1.2), 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		#tween.parallel().tween_property(power_up, "rotation", TAU, 0.3) \
		#	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		tween.parallel().tween_property(power_up, "modulate", color, 0.2) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
			
			
		tween.tween_property(power_up, "global_position", pos, 0.3) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		tween.parallel().tween_property(power_up, "modulate", Color(color, 0.5), 0.3) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
			
		tween.tween_property(power_up, "scale", Vector2(1.8, 1.8), 0.3) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		
		var description = DESCRIPTION_PREFAB.instantiate()
		description.get_node("Description").text = power_up.description
		description.modulate = Color(1, 1, 1, 0)
		get_parent().add_child(description)
		description.global_position = Vector2(1920 / 2, 1080 / 2)
		
		tween.parallel().tween_property(description, "scale", Vector2(1.2, 1.2), 1) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(description, "modulate", color, 1) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(description, "global_position", description.global_position + Vector2(0, -300), 1) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(description, "scale", Vector2.ZERO, 0.3) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_callback(description.queue_free)
		
		
	
	tween.tween_property(power_up, "scale", Vector2.ZERO, 0.3) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		
	#tween.tween_property(power_up, "rotation", .2, .1) \
	#	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	#tween.tween_property(power_up, "rotation", -.2, .1) \
	#	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	#tween.tween_property(power_up, "rotation", 0, .1) \
	#	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	#tween.parallel().tween_property(power_up, "scale", Vector2.ZERO, 0.5) \
	#	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	#tween.parallel().tween_property(power_up, "position", Vector2(0,-300), 1.5) \
	#	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	#tween.parallel().tween_property(power_up, "modulate", Color(Color.WHITE, 0), 2) \
	#	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	power_up.execute(touched_by)
	
