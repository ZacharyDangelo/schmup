extends "res://scripts/weapons/base_weapon.gd"


@export var angle_threshold: float = .9
@export var burst_delay: float = .2
@export var burst_amount: int = 3
@export var debug: bool = false

var is_bursting
var burst_count
var current_burst_timer
var player

func _ready():
	is_bursting = false
	burst_count = 0
	current_burst_timer = 0
	super()

func _process(delta):
	super(delta)
	if debug:
		queue_redraw()
	if is_bursting:
		handle_burst(delta)
	if should_start_firing():
		is_bursting = true
		fire()

func handle_burst(delta):
	current_burst_timer += delta
	if burst_count >= burst_amount:
		is_bursting = false
		current_burst_timer = 0
		current_fire_timer = 0
		burst_count = 0
	if current_burst_timer >= burst_delay:
		fire()
		current_burst_timer = 0
		burst_count += 1
	
func fire():
	var proj = projectile.instantiate()
	proj.position = fire_point.global_position
	proj.rotation = get_parent().rotation
	if weapon_type == WeaponType.PLAYER:
		proj.dir = Vector2.RIGHT
	else:
		proj.dir = Vector2.LEFT
	get_tree().current_scene.add_child(proj)
	current_fire_timer = 0


func should_start_firing():
	if is_bursting:
		return false
	if current_fire_timer < fire_delay:
		return false
	if is_looking_at_player(get_parent().player):
		return true

func is_looking_at_player(player: Node2D) -> bool:
	var enemy = get_parent() as Node2D
	
	# Enemy is oriented left by default, so we use Vector2.LEFT
	var enemy_facing = Vector2.LEFT.rotated(enemy.rotation)
	var to_player = (player.global_position - enemy.global_position).normalized()
	
	var dot = enemy_facing.dot(to_player)
	
	# If you want them almost perfectly aligned, set a high threshold like 0.9 or 0.95
	return dot > angle_threshold
	
func _draw():
	if not debug:
		return
	var player = get_parent().player
	if player:
		var enemy_facing = Vector2.LEFT.rotated(get_parent().rotation) * 50
		var to_player = (player.global_position - global_position).normalized() * 50

		# Convert to local coordinates before drawing
		draw_line(Vector2.ZERO, to_local(global_position + enemy_facing), Color.RED, 2)
		draw_line(Vector2.ZERO, to_local(global_position + to_player), Color.GREEN, 2)
