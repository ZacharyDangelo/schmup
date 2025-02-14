extends Node2D

@export var fire_delay: float
@export var projectile: PackedScene

var current_fire_timer = 0
var projectile_container

func _process(delta):
	current_fire_timer += delta
	if(current_fire_timer >= fire_delay):
		fire()
		
func fire():
	var proj = projectile.instantiate()
	proj.position = global_position
	get_tree().current_scene.add_child(proj)
	current_fire_timer = 0
