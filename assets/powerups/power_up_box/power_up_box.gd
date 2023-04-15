extends StaticBody2D


func destroy_box():
	$Sprite2D.modulate(Color(Color.WHITE, 0))
	spawn_random_power_up()

func spawn_random_power_up():
	pass
