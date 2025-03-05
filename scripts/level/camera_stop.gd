extends Node2D


func _on_visible_on_screen_notifier_2d_screen_entered():
	Util.get_camera().stop()
