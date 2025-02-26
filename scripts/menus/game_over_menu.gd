extends Control

func _ready():
	get_node("%Player").on_died.connect(show_menu)

func show_menu():
	self.visible = true


func _on_button_pressed():
	get_tree().reload_current_scene()
