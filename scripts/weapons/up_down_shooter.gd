extends "res://scripts/weapons/base_weapon.gd"


@export var angle: float 

var camera
var dir

func _ready():
	super()
	var midpoint = Util.get_camera().get_screen_center_position()
	if get_parent().global_position.y < midpoint.y:
		dir = -1
	else:
		dir = 1

func fire():
	var proj = projectile.instantiate()
	proj.dir = Vector2.LEFT
	proj.position = fire_point.global_position
	proj.rotation = deg_to_rad(dir * angle)
	get_tree().current_scene.add_child(proj)
	current_fire_timer = 0
