extends Timer



func _on_timeout():
	if not Global.commentary_player.playing:
		Global.play_commentary_random()
