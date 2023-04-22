extends Node

const MAIN_MENU_SCENE_PATH := "res://scenes/main_menu/main_menu.tscn"

var level_entry_animation_active := false


func _ready() -> void:
	Signals.level_entry_animation_started.connect(_on_level_entry_animation_started)
	Signals.level_entry_animation_finished.connect(_on_level_entry_animation_finished)


func _process(_delta):
	if Input.is_action_just_pressed("reset_ball"):
		var ball = get_parent().get_node("Ball")
		ball.set_to_position(get_viewport().get_visible_rect().get_center())


	if Input.is_action_just_pressed("change_level_settings"):
		var level_manager = get_parent().get_node("LevelManager")
		level_manager.set_random_level_settings()


	if Input.is_action_just_pressed("exit"):
		if get_tree().current_scene.scene_file_path == MAIN_MENU_SCENE_PATH and not level_entry_animation_active:
			get_tree().quit()
		
		stop__all_sfx()
		get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)
		Signals.emit_signal("level_entry_animation_finished")


func stop__all_sfx():
	var sfx_nodes = get_tree().get_nodes_in_group("sfx")
	for sfx in sfx_nodes:
		sfx.stop()


func _on_level_entry_animation_started() -> void:
	level_entry_animation_active = true


func _on_level_entry_animation_finished() -> void:
	level_entry_animation_active = false
