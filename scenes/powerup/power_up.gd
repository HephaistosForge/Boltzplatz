extends Sprite2D

const powerup_variants = [ 
	preload("res://assets/powerups/pokal_1.png"),
	preload("res://assets/powerups/star_1.png"),
	preload("res://assets/powerups/thunder_1.png"),
	preload("res://assets/powerups/wind_1.png")
]

const texts = [
	"Bonuspunkt!",
	"Gegner verliert Punkt!",
	"Gegnersabotage!",
	"Kickstärke!",
]

var description

const REDUCE_TIME = 10.0
const KICK_POWER_TIME = 10.0

var variant

var player
var other_player

func _ready() -> void:
	self.texture = powerup_variants[variant]
	self.description = texts[variant]


func execute(_player):
	match _player:
		Rod.PLAYER_TYPE.PLAYER_LEFT:
			player = get_tree().get_first_node_in_group("Player_Left")
			other_player = get_tree().get_first_node_in_group("Player_Right")
		Rod.PLAYER_TYPE.PLAYER_RIGHT:
			player = get_tree().get_first_node_in_group("Player_Right")
			other_player = get_tree().get_first_node_in_group("Player_Left")
			
	match variant:
		0:
			add_point_to_player(player)
		1:
			remove_point_from_player(other_player)
		2:
			reduce_player_size(other_player)
		3:
			improve_player_kick_power(player)


func add_point_to_player(_player):
	_player.add_point()
	
	
func remove_point_from_player(_player):
	_player.remove_point()
	
	
func reduce_player_size(_player):
	_player.reduce_size(REDUCE_TIME)


func improve_player_kick_power(_player):
	_player.increase_kick_power(KICK_POWER_TIME)
