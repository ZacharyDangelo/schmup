extends CanvasLayer
@onready var main = $Main
@onready var options = $Options
@export var main_scene: PackedScene

func _on_options_button_pressed():
	main.hide()
	options.show()


func _on_button_pressed():
	main.show()
	options.hide()


func _on_play_button_pressed():
	get_tree().change_scene_to_packed(main_scene)


func _on_master_slider_value_changed(value):
	Settings.change_master_volume(value)
