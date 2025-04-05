extends "res://scripts/powerups/base_power_up.gd"

func on_pickup():
	super()
	# Kill everything on screen
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if Util.is_node_on_screen(enemy):
			enemy.kill(true)
