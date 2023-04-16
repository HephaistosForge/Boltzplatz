extends PanelContainer

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func set_win_text(_text, color):
	$MarginContainer/PanelContainer/game_over.text = _text
	self.modulate = color
