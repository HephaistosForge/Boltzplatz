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
			destroy_box()


func destroy_box():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1.2, .8), 0.1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "scale", Vector2(.8, 1.2), 0.1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "position", Vector2(0, -200), 0.2) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_callback(execute_power_up)
	tween.tween_property($Sprite2D, "scale", Vector2.ONE * 1.4, 0.2) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0.2) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)


func execute_power_up():
	power_up = POWER_UP_PREFAB.instantiate()
	power_up.variant = randi_range(0,3)
	self.add_child(power_up)
	
	var tween = create_tween()
	power_up.scale = Vector2.ZERO
	power_up.modulate = Color.WHITE
	power_up.position = Vector2(0, -200)
	tween.tween_property(power_up, "scale", Vector2(1, 1), 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		
	if touched_by != null:
		var is_left = Rod.PLAYER_TYPE.PLAYER_LEFT == touched_by
		var color = Color.BLUE if is_left else Color.RED
		var pos = Vector2(300 if is_left else 1920 - 300, 1080 / 2)
			
		_highlight_powerup(tween, color)
		_move_powerup(tween, pos, color)
		_dehighlight_powerup(tween)
		_show_description(tween, color)
		
	_fade_powerup(tween)
	power_up.execute(touched_by)
	
	
func _highlight_powerup(tween: Tween, color: Color):
	tween.tween_property(power_up, "scale", Vector2(1.2, 1.2), 0.3) \
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(power_up, "modulate", color, 0.2) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		
		
func _dehighlight_powerup(tween: Tween):
	tween.tween_property(power_up, "scale", Vector2(1.8, 1.8), 0.3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		


func _move_powerup(tween: Tween, pos: Vector2, color: Color):
	tween.tween_property(power_up, "global_position", pos, 0.3) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(power_up, "modulate", Color(color, 0.5), 0.3) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)


func _fade_powerup(tween: Tween):
	tween.tween_property(power_up, "scale", Vector2.ZERO, 0.3) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)


func _show_description(tween: Tween, color: Color):
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
