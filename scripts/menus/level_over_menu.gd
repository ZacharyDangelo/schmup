extends Control

signal on_continue_button_pressed()

func show_menu():
	self.visible = true
	get_node("../ScoreLabel").visible = false
	
func _on_button_pressed():
	self.visible = false
	on_continue_button_pressed.emit()
	
