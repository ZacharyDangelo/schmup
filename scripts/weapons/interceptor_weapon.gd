extends "res://scripts/weapons/base_weapon.gd"

func create_projectile():
	var proj = projectile.instantiate()
	# Calc direction
	var parent_pos = fire_point.global_position
	var player_pos = get_parent().player.get_center_position()
	var direction = (player_pos - parent_pos).normalized()
	proj.position = fire_point.global_position
	proj.dir = direction
	return proj
