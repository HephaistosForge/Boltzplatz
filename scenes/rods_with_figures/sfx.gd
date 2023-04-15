extends AudioStreamPlayer2D


func play_with_random_pitch() -> void:
	self.pitch_scale = randf_range(0.9, 1.4) # Fine tuned for slight sound variation
	self.play()
