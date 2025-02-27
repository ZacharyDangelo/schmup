extends Control

func _ready():
	get_node("%Player").on_died.connect(show_menu)

func show_menu():
	self.visible = true
	get_node("../ScoreLabel").visible = false


func _on_button_pressed():
	get_tree().reload_current_scene()
