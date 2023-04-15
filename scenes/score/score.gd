extends Control

@onready var label_player_left = $HBoxContainer/LabelPlayerLeft
@onready var label_player_right = $HBoxContainer/LabelPlayerRight
@onready var ball = get_tree().get_first_node_in_group("Ball")

const WIN_DIALOG_PREFAB = preload("res://scenes/score/popup.tscn")
const POINTS_TO_WIN = 6

var score_player_left = 0
var score_player_right = 0
var text

func _ready():
	_update_ui()

func add_one_to_player_left():
	score_player_left += 1
	_update_ui()
	check_score()
	
func add_one_to_player_right():
	score_player_right += 1
	_update_ui()
	check_score()

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

func check_score():
	if score_player_left >= POINTS_TO_WIN or score_player_right >= POINTS_TO_WIN:
		ball.game_over = true
		var win_dialog = WIN_DIALOG_PREFAB.instantiate()
		if score_player_left >= POINTS_TO_WIN:
			text = "Player Blau hat gewonnen!"
		if score_player_right >= POINTS_TO_WIN:
			text = "Player Rot hat gewonnen!"
		self.add_child(win_dialog)
		win_dialog.set_win_text(text)
