extends Node2D

enum WeaponType { PLAYER, ENEMY}

@export var weapon_type: WeaponType
@export_group("Stats")
@export var auto_fire: bool
@export var fire_delay: float
@export_group("Projectile")
@export var projectile: PackedScene


var current_fire_timer = 0
var projectile_container
var fire_point:Node2D

func _ready():
	fire_point = get_node("FirePoint")
	
func _process(delta):
	if not auto_fire:
		return
	current_fire_timer += delta
	if(current_fire_timer >= fire_delay):
		fire()

func fire():
	var proj = projectile.instantiate()
	proj.position = fire_point.global_position
	if weapon_type == WeaponType.PLAYER:
		proj.dir = Vector2.RIGHT
	else:
		proj.dir = Vector2.LEFT
	get_tree().current_scene.add_child(proj)
	current_fire_timer = 0
