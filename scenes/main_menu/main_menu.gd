extends Control

@onready var default_continent = preload("res://world.tscn")


func _on_dummy_country_button_pressed():
	get_tree().change_scene_to_packed(default_continent)
