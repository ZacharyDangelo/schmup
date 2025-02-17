extends Node2D

@export var projectile: PackedScene

func fire():
	print('firing sine cannon!')
	var proj = projectile.instantiate()
	proj.position = global_position
	var player_group = get_tree().get_nodes_in_group("Player")
	if not player_group:
		push_warning('Cant find player in sine_cannon fire function')
		return
	var player = player_group[0]
	print('creating sine cannon proj')
	proj.target_pos = player.global_position
	get_tree().current_scene.add_child(proj)


func _on_movement_peak_reached():
	fire()
