extends Control


func show_menu():
	self.visible = true
	get_node("../ScoreLabel").visible = false
	
func _on_button_pressed():
	get_tree().reload_current_scene()
