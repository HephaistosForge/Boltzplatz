extends PanelContainer

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func set_win_text(_text):
	$MarginContainer/PanelContainer/winner_is.text = _text
