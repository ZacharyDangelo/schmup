extends CanvasLayer

var score
var game_over_menu
var game_over_menu_score_label

var level_over_menu
var level_over_menu_score_label
var score_label

var is_player_dead

func _ready():
	score = 0
	is_player_dead = false
	game_over_menu = get_node("GameOverMenu")
	game_over_menu_score_label = game_over_menu.get_node("PanelContainer/ScoreLabel")
	level_over_menu = get_node("LevelOverMenu")
	level_over_menu_score_label = level_over_menu.get_node("PanelContainer/ScoreLabel")
	score_label = get_node("ScoreLabel")

func _on_enemy_killed(points: int):
	if is_player_dead:
		return
	score += points
	score_label.text = "Score: %s" % score
	game_over_menu_score_label.text = "Score: %s" % score
	level_over_menu_score_label.text = "Score: %s" % score


func _on_player_on_died():
	is_player_dead = true
