extends "res://scripts/enemy/base_enemy.gd"
@export var distance_threshold: float
@export_group("Spawn")
@export var spawning_speed: float
@export var distance_after_spawn: Vector2
@export_group("Orbit")
@export var orbit_speed: float
@export var orbit_radius: float
@export_group("Movement")
@export var moving_speed: float
@export var distance_from_parent: Vector2
@export_group("Attack")
@export var attack_move_speed: float
@export var attack_delay: float 
@export var attack_offset: Vector2
@export var attack_distance: float


enum State {SPAWNING, ORBIT, MOVING, ATTACKING, FIRING, RECOVERY}

var curr_state
var carrier_node
var movement_target
var curr_angle = 0.0
var curr_attack_timer

var attack_position
var firing

func _ready():
	super()
	curr_state = State.SPAWNING
	movement_target = position + distance_after_spawn
	curr_attack_timer = 0
	attack_position = null
	if not carrier_node:
		push_error("Intercept must have a valid carrier node")
		self.queue_free()
	
func _process(delta):
	#handle_common_behavior()
	if curr_state == State.SPAWNING:
		handle_spawning_state(delta)
	elif curr_state == State.ORBIT:
		handle_orbit_state(delta)
	elif curr_state == State.MOVING:
		handle_moving_state(delta)
	elif curr_state == State.ATTACKING:
		handle_attacking_state(delta)
	elif curr_state == State.FIRING:
		handle_firing_state(delta)
	elif curr_state == State.RECOVERY:
		handle_recovery_state(delta)
		
func handle_spawning_state(delta):
	position += movement_target.normalized() * delta * spawning_speed
	if position.distance_to(movement_target) <= distance_threshold:
		curr_angle = (position - carrier_node.position).angle()
		curr_state = State.ORBIT
	
func handle_moving_state(delta):
	pass

func handle_orbit_state(delta):
	curr_angle += orbit_speed * delta  # Rotate over time
	rotation = lerp_angle(rotation, curr_angle, delta * .56)
	# Calculate new position around center_enemy
	var offset = Vector2(orbit_radius, 0).rotated(curr_angle)
	global_position = carrier_node.global_position + offset
	curr_attack_timer += delta
	if curr_attack_timer >= attack_delay and curr_angle >= 8:
		curr_state = State.ATTACKING
		var attack_dir = [-1,1].pick_random()
		attack_position = player.global_position - (attack_offset * attack_dir)
		curr_attack_timer = 0
	
func handle_attacking_state(delta):
	var dir = global_position.direction_to(attack_position)
	var target_angle = dir.angle()
	# Move towards attack target
	global_position += dir * delta * attack_move_speed
	rotation = lerp_angle(rotation, target_angle + PI, delta * 1)
	# If close enough, start shooting
	if global_position.x - attack_position.x < attack_distance:
		curr_state = State.FIRING

func handle_firing_state(delta):
	var dir = global_position.direction_to(player.get_center_position())
	var target_angle = dir.angle()
	rotation = target_angle + PI
	weapon.fire()
	curr_state = State.RECOVERY

func handle_recovery_state(delta):
	var dir = position.direction_to(movement_target)
	var target_angle = dir.angle()
	# Move back to orbit
	position += position.direction_to(movement_target) * attack_move_speed * delta
	rotation = lerp_angle(rotation, target_angle + PI, delta * 5)
	# If close enough, resume orbiting
	if position.distance_to(movement_target) <= distance_threshold:
		curr_angle = (position - carrier_node.position).angle()
		curr_state = State.ORBIT
