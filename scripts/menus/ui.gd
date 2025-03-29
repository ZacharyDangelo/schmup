extends CanvasLayer

var game_over_menu
var game_over_menu_score_label

var level_over_menu
var level_over_menu_score_label
@onready var score_label = $HUD/HBoxContainer/ScoreLabel
@onready var timer_label = $HUD/HBoxContainer/TimerLabel
@onready var lives_container = $HUD/HBoxContainer/Lives_HBoxContainer
@onready var hud = $HUD
@onready var pause_menu = $PauseMenu



var is_player_dead
var current_timer = 0

func _ready():
	is_player_dead = false
	game_over_menu = get_node("GameOverMenu")
	game_over_menu_score_label = game_over_menu.get_node("PanelContainer/ScoreLabel")
	level_over_menu = get_node("LevelOverMenu")
	level_over_menu_score_label = level_over_menu.get_node("PanelContainer/ScoreLabel")

	GameData.on_score_changed.connect(update_score_label)
	pause_menu.connect("on_game_resumed",func():hud.show())
	if GameData.current_lives == 2:
		lives_container.get_child(2).set_indexed("modulate:a",0)
	if GameData.current_lives == 1:
		lives_container.get_child(1).set_indexed("modulate:a",0)
		

func _process(delta):
	if is_player_dead:
		return
	handle_timer(delta)
	if Input.is_action_just_pressed("pause") and can_pause():
		Engine.time_scale = 0
		pause_menu.show()
		hud.hide()
	
func can_pause():
	return !game_over_menu.visible and !level_over_menu.visible


func handle_timer(delta):
	current_timer += delta
	var minutes = int(current_timer / 60)
	var seconds = int(current_timer) % 60
	var milliseconds = int((current_timer - int(current_timer)) * 100)
	# Format using template strings with padding
	timer_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

func update_score_label(value: int):
	score_label.text = "Score: " + str(GameData.score)
	level_over_menu_score_label.text =  "Score: " + str(GameData.score)
	game_over_menu_score_label.text = "Score: " + str(GameData.score)

func _on_player_on_died():
	is_player_dead = true
	hud.hide()


func _on_player_on_life_lost():
	lives_container.get_child(GameData.current_lives).set_indexed("modulate:a",0)
