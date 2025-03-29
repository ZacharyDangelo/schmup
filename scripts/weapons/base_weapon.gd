extends Node2D

enum WeaponType { PLAYER, ENEMY}

@export var weapon_type: WeaponType
@export_group("Stats")
@export var auto_fire: bool
@export var fire_delay: float
@export_group("Projectile")
@export var projectile: PackedScene
@export var projectile_speed: float = -1

var active

var current_fire_timer = 0
var projectile_container
var fire_point:Node2D

func _ready():
	if weapon_type == WeaponType.PLAYER:
		active = true
	else:
		active = false
	fire_point = get_node("FirePoint")
	
func _process(delta):
	if not active:
		return
	current_fire_timer += delta
	if not auto_fire:
		return
	if(current_fire_timer >= fire_delay):
		fire()

func create_projectile():
	var proj = projectile.instantiate()
	proj.position = fire_point.global_position
	if weapon_type == WeaponType.PLAYER:
		proj.dir = Vector2.RIGHT
	else:
		proj.dir = Vector2.LEFT
	if projectile_speed != -1:
		proj.speed = projectile_speed
	return proj

func fire():
	var proj = create_projectile()
	get_tree().current_scene.add_child(proj)
	current_fire_timer = 0
