extends Node2D

@export var fire_delay:float = 1.2
@export var projectile:PackedScene


var fire_timer = 0
var fire_point

func _ready():
	fire_point = get_node("FirePoint")
	
func _process(delta):
	fire_timer += delta
	if fire_timer >= fire_delay:
		fire()
		
func fire():
	fire_timer = 0
	var proj = projectile.instantiate()
	proj.position = fire_point.global_position
	proj.rotation = get_parent().rotation - deg_to_rad(90)
	get_tree().current_scene.add_child(proj)
