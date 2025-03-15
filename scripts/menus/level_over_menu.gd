extends Control

signal on_continue_button_pressed()
@onready var score_label = $"../HUD/HBoxContainer/ScoreLabel"

func show_menu():
	self.visible = true
	score_label.visible = false
	
func _on_button_pressed():
	GameData.set_level(GameData.current_level + 1)
