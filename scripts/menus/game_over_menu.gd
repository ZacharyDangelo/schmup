extends Control
@onready var victory_graphics = $VictoryGraphics
@onready var score_label = $"../HUD/HBoxContainer/ScoreLabel"
@onready var click_sfx = preload("res://audio/sfx/Click_Electronic_14.wav")

func _ready():
	get_node("%Player").on_died.connect(show_menu)

func show_menu():
	self.visible = true
	score_label.visible = false

func victory():
	victory_graphics.show()

func _on_button_pressed():
	get_node("%Player").reset()
	SFXManager.play(click_sfx)
	GameData.score = 0
	GameData.set_level(0)
	GameData.set_lives(3)
