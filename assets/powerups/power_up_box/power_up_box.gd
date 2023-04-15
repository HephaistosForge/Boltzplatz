extends StaticBody2D

const POWER_UP_PREFAB = preload("res://assets/powerups/power_up.tscn")

var tween
var power_up

func _ready():
	destroy_box()


func destroy_box():
	tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(Color.WHITE, 0), 0.5)
	tween.tween_callback(spawn_power_up)


func spawn_power_up():
	power_up = POWER_UP_PREFAB.instantiate()
	power_up.variant = randi_range(0,3)
	self.add_child(power_up)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(power_up, "modulate", Color(Color.WHITE, 1), 0.3)
	tween.tween_property(power_up, "scale", Vector2(1.2, 1.2), 0.4)
	tween.parallel().tween_property(power_up, "position", Vector2(0,-500), 2)
	tween.parallel().tween_property(power_up, "modulate", Color(Color.WHITE, 0), 2)
