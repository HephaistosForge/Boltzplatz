extends Control

@onready var container = $HBoxContainer
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
	
func remove_one_from_player_left():
	score_player_left -= 1
	_update_ui()

func reset_score():
	score_player_left = 0
	score_player_right = 0
	_update_ui()
	
func _update_ui():
	var left_changed = label_player_left.text != str(score_player_left)
	var right_changed = label_player_right.text != str(score_player_right)
	label_player_left.text = str(score_player_left)
	label_player_right.text = str(score_player_right)
	
	var changed = int(left_changed) - int(right_changed)
	if changed:
		var label = {1: label_player_left, -1: label_player_right}[changed]
		var time = 1
		var tween = create_tween()
		
		tween.tween_property(container, "rotation", .05 * changed, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(label, "scale", Vector2.ONE * 2, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		var color = Color.BLUE if changed == 1 else Color.RED
		tween.parallel().tween_property(label, "modulate", color, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			
		tween.tween_property(container, "rotation", 0, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(label, "scale", Vector2.ONE, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.parallel().tween_property(label, "modulate", Color.WHITE, time) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func check_score():
	if score_player_left >= POINTS_TO_WIN or score_player_right >= POINTS_TO_WIN:
		ball.game_over = true
		var win_dialog = WIN_DIALOG_PREFAB.instantiate()
		if score_player_left >= POINTS_TO_WIN:
			text = "Spieler Blau hat gewonnen!"
		if score_player_right >= POINTS_TO_WIN:
			text = "Spieler Rot hat gewonnen!"
		self.add_child(win_dialog)
		win_dialog.set_win_text(text)
