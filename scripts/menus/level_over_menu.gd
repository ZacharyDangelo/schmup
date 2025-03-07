extends Control

signal on_continue_button_pressed()

func show_menu():
	self.visible = true
	get_node("../ScoreLabel").visible = false
	
func _on_button_pressed():
	GameData.set_level(GameData.current_level + 1)
