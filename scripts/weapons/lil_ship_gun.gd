extends "res://scripts/weapons/base_weapon.gd"

@export var debug: bool = false
@export var distance_to_fire: float = 250
@export var projectile_y_offset: float = -35

func _process(delta):
	if debug:
		queue_redraw()
	if should_fire():
		get_parent().has_fired = true
		fire()

func should_fire():
	if get_parent().has_fired:
		return
	var player_pos = get_parent().player.global_position.x
	var parent_pos = get_parent().global_position.x
	return parent_pos - player_pos <= distance_to_fire

func create_projectile():
	var proj = projectile.instantiate()
	# Calc direction
	var parent_pos = get_parent().global_position
	var player_pos = get_parent().player.global_position +Vector2(0, projectile_y_offset)
	var direction = (player_pos - parent_pos).normalized()
	
	proj.position = fire_point.global_position
	proj.dir = direction
	return proj


func _draw():
	if not debug:
		return
	var parent_pos = get_parent().global_position
	var player_pos = get_parent().player.global_position

	var direction = (player_pos - parent_pos).normalized()
	var end_point = parent_pos + direction * 100  # Extend line 100 pixels

	draw_line(parent_pos - global_position, end_point - global_position, Color.RED, 2)
