extends "res://scripts/weapons/base_weapon.gd"


var fire_timer = 0

func _ready():
	super()
	
func _process(delta):
	super(delta)
		
func fire():
	fire_timer = 0
	var proj = projectile.instantiate()
	proj.position = fire_point.global_position
	proj.rotation = get_parent().rotation - deg_to_rad(90)
	get_tree().current_scene.add_child(proj)
