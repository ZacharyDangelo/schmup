extends Node2D

signal level_stopped()

func _ready():
	var ui_group = get_tree().get_nodes_in_group("UI")
	if not ui_group:
		push_error('Cant find UI')
		return
	print('here')
	print(ui_group[0].get_node("LevelOverMenu"))
	level_stopped.connect(ui_group[0].get_node("LevelOverMenu").show_menu)

func _on_area_2d_area_entered(area):
	level_stopped.emit()
