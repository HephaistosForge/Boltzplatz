extends Control

@onready var label_player_left = $HBoxContainer/LabelPlayerLeft
@onready var label_player_right = $HBoxContainer/LabelPlayerRight

var score_player_left = 0
var score_player_right = 0

func _ready():
	_update_ui()

func add_one_to_player_left():
	score_player_left += 1
	_update_ui()
	
func add_one_to_player_right():
	score_player_right += 1
	_update_ui()

func remove_one_from_player_right():
	score_player_right -= 1
	_update_ui()
	
func remove_one_from_player_lef():
	score_player_left -= 1
	_update_ui()

func reset_score():
	score_player_left = 0
	score_player_right = 0
	_update_ui()
	
func _update_ui():
	label_player_left.text = str(score_player_left)
	label_player_right.text = str(score_player_right)
