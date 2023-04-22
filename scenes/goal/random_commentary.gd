extends Timer


func _on_timeout():
	if not Global.commentary_player.playing and not Global.game_finished:
		Global.play_commentary_random()
