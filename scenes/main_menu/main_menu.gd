extends Control

const default_continent = preload("res://world.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

