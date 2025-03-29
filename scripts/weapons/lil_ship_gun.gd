extends "res://scripts/weapons/base_weapon.gd"

@export var distance_to_fire: float = 250

func _ready():
	super()
	projectile_speed = 800

func _process(delta):
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
	var parent_pos = fire_point.global_position
	var player_pos = get_parent().player.get_center_position()
	var direction = (player_pos - parent_pos).normalized()
	
	proj.position = fire_point.global_position
	proj.dir = direction
	proj.speed = projectile_speed
	return proj
