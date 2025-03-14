extends "res://scripts/weapons/base_weapon.gd"

@export var spawn_distance: float
@export var num_projectiles: float
@export var repeat_delay: float


func _ready():
	super()
	var animation_player = get_node("../AnimationPlayer")
	if animation_player:
		animation_player.play("fire")

func _process(delta):
	#super(delta)
	pass
	

func fire():
	if not get_parent().awake:
		return
	var rotation_per_step = 45
	var curr_rotation = 0
	for i in range(num_projectiles):
		var proj = projectile.instantiate()
		proj.position = fire_point.global_position + Vector2(0,spawn_distance).rotated(deg_to_rad(curr_rotation))
		proj.rotation = deg_to_rad(curr_rotation)
		proj.dir = Vector2.DOWN
		get_tree().current_scene.add_child(proj)
		curr_rotation += rotation_per_step
	current_fire_timer = -repeat_delay
