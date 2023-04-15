extends Control

<<<<<<< HEAD
const default_continent = preload("res://world.tscn")
=======
@onready var default_continent = preload("res://world.tscn")


func _on_dummy_country_button_pressed():
	get_tree().change_scene_to_packed(default_continent)
	Global.selected_level_settings = Global.LEVEL_SETTINGS.SAND
	print("pressed")
>>>>>>> 923a7297c5fe5a30cd976bbb7c85e50c285be020
