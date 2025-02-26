extends CanvasLayer

var score
var game_over_menu
var game_over_menu_score_label
var score_label

func _ready():
	score = 0
	game_over_menu = get_node("GameOverMenu")
	game_over_menu_score_label = game_over_menu.get_node("PanelContainer/ScoreLabel")
	score_label = get_node("ScoreLabel")

func _on_enemy_killed(points: int):
	print('Enemy killed!')
	score += points
	score_label.text = "Score: %s" % score
	game_over_menu_score_label.text = "Score: %s" % score
