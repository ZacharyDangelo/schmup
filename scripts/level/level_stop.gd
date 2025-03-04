extends Node2D


signal level_stopped()

func _ready():
	pass

func _on_area_2d_area_entered(area):
	level_stopped.emit()
