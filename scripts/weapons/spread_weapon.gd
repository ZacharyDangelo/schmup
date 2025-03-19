extends "res://scripts/weapons/base_weapon.gd"

@export var spread_projectile_count: int
@export var spread_amount_deg: float



func _process(delta):
	if get_parent().dead || get_parent().respawning:
		return
	super(delta)
	if Input.is_action_pressed("shoot") and (current_fire_timer >= fire_delay):
		fire()

func fire():
	var curr_rotation = -spread_amount_deg
	for i in range(0,spread_projectile_count):
		var proj = projectile.instantiate()
		proj.position = fire_point.global_position
		proj.rotation = -deg_to_rad(curr_rotation)
		curr_rotation += spread_amount_deg
		if weapon_type == WeaponType.PLAYER:
			proj.dir = Vector2.RIGHT
		else:
			proj.dir = Vector2.LEFT
		get_tree().current_scene.add_child(proj)
		current_fire_timer = 0
