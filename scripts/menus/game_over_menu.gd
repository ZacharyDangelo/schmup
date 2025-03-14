extends Control
@onready var victory_graphics = $VictoryGraphics
@onready var score_label = $"../HUD/HBoxContainer/ScoreLabel"

func _ready():
	get_node("%Player").on_died.connect(show_menu)

func show_menu():
	self.visible = true
	score_label.visible = false

func victory():
	victory_graphics.show()

func _on_button_pressed():
	GameData.score = 0
	GameData.set_level(0)
	get_tree().reload_current_scene()
