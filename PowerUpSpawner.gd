extends Node

const MIN_X = 130
const MAX_X = 1590
const MIN_Y = 130
const MAX_Y = 960 

const POWER_UP_BOX_PREFAB = preload("res://assets/powerups/power_up_box/power_up_box.tscn")


func _on_timer_timeout() -> void:
	var power_up_prefab = POWER_UP_BOX_PREFAB.instantiate()
	add_child(power_up_prefab)
	power_up_prefab.global_position = Vector2i(randi_range(MIN_X, MAX_X), randi_range(MIN_Y, MAX_Y))
