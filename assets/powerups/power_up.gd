extends Sprite2D

const powerup_variants = [ 
	preload("res://assets/powerups/pokal_1.png"),
	preload("res://assets/powerups/star_1.png"),
	preload("res://assets/powerups/thunder_1.png"),
	preload("res://assets/powerups/wind_1.png")
]

var variant


func _ready() -> void:
	self.texture = powerup_variants[variant]


func execute(_player, _other_player):
	match variant:
		0:
			add_point_to_player(_player)
		1:
			remove_point_from_player(_other_player)
		2:
			reduce_player_size(_other_player)
		3:
			improve_player_kick_power(_player)


func add_point_to_player(_player):
	pass
	
	
func remove_point_from_player(_player):
	pass
	
	
func reduce_player_size(_player):
	pass


func improve_player_kick_power(_player):
	pass
