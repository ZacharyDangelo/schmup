extends "res://scripts/weapons/base_weapon.gd"

func fire():
	var proj = create_positioned_projectile(fire_point.global_position)
	get_tree().current_scene.add_child(proj)
	var offset_fire_point_pos = Vector2(fire_point.position.x, fire_point.position.y * -1)
	var proj2 = create_positioned_projectile(to_global(offset_fire_point_pos))
	get_tree().current_scene.add_child(proj2)
	current_fire_timer = 0


func create_positioned_projectile(fire_point_position):
	var proj = projectile.instantiate()
	# Calc direction
	var parent_pos = fire_point_position
	var player_pos = get_parent().player.get_center_position()
	var direction = (player_pos - parent_pos).normalized()
	proj.position = fire_point.global_position
	proj.dir = direction
	return proj
