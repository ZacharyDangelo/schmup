extends "res://scripts/weapons/base_weapon.gd"

@export var num_projectiles: int
@export var repeat_delay: float
@export var spawn_distance: float
@export var max_shots: int


var current_shots
func _ready():
	super()
	current_shots = 0
	
func _process(delta):
	pass
	
	
func fire():
	print('fire!')
	if not get_parent().awake:
		return
	current_shots += 1
	var rotation_per_step = 15
	var start_rotation = -rotation_per_step * (num_projectiles - 1) / 2  # Center the arc
	var curr_rotation = start_rotation
	
	for i in range(num_projectiles):
		var proj = projectile.instantiate()
		proj.position = fire_point.global_position + Vector2(0, spawn_distance).rotated(deg_to_rad(curr_rotation))
		proj.rotation = deg_to_rad(curr_rotation)  # For visual rotation
		proj.dir = Vector2.LEFT.rotated(deg_to_rad(curr_rotation))  # Actual movement direction
		get_tree().current_scene.add_child(proj)
		curr_rotation += rotation_per_step
	
	current_fire_timer = -repeat_delay
