extends CanvasLayer

var game_over_menu
var game_over_menu_score_label

var level_over_menu
var level_over_menu_score_label
var score_label

var is_player_dead

func _ready():
	is_player_dead = false
	game_over_menu = get_node("GameOverMenu")
	game_over_menu_score_label = game_over_menu.get_node("PanelContainer/ScoreLabel")
	level_over_menu = get_node("LevelOverMenu")
	level_over_menu_score_label = level_over_menu.get_node("PanelContainer/ScoreLabel")
	score_label = get_node("ScoreLabel")
	GameData.on_score_changed.connect(update_score_label)

func update_score_label(value: int):
	score_label.text = "Score: " + str(GameData.score)
	level_over_menu_score_label.text =  "Score: " + str(GameData.score)
	game_over_menu_score_label.text = "Score: " + str(GameData.score)

func _on_player_on_died():
	is_player_dead = true
