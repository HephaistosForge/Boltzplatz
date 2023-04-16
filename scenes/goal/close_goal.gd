extends Area2D


func _on_body_entered(body):
	await get_tree().create_timer(.4).timeout
	if not Global.commentary_player.playing:
		Global.play_commentary_close()
