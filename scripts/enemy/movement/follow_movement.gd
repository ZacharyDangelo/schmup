extends Node2D



@export var speed: float = 100.0
@export var y_speed: float = 100
@export var distance_from_edge: float = 50.0
@export var vertical_move_amount: float = 50.0
@export var min_target_distance: float = 20.0  # Minimum vertical difference for a new target
@export var leaving_timer: float = 2.4

@export var x_sway_amount: float = 10



var enemy_node 
var camera
var target_x: float
var target_y: float
var max_y: float
var min_y: float
@export var threshold: float = 5.0             # Distance threshold to trigger a new target
var current_leaving_timer
var sway_starting_position: Vector2

func _ready():
	enemy_node = get_parent()  
	camera = enemy_node.get_camera() 
	# Calculate target x position so the enemy stops at 'distance_from_edge' inside the camera bounds.
	target_x = camera.get_right_position_bounds() - distance_from_edge
	max_y = camera.get_upper_position_bounds()
	min_y = camera.get_lower_position_bounds()
	target_y = randf_range(min_y, max_y)
	current_leaving_timer = 0 


func handle_entering_state(delta):
		handle_y_movement(delta)
		# Move left until the enemy's x position reaches or is less than the target.
		if enemy_node.global_position.x > target_x:
			enemy_node.global_position.x -= speed * delta
		else:
			# When reaching the target, switch to FIGHTING state.
			enemy_node.current_state = enemy_node.State.FIGHTING

func handle_fighting_state(delta):
	handle_y_movement(delta)
	handle_x_sway(delta)

func handle_leaving_state(delta):
	if current_leaving_timer <= leaving_timer:
		handle_y_movement(delta)
		handle_x_sway(delta)
	else:
		leave(delta)
	current_leaving_timer += delta
	

func leave(delta):
	enemy_node.global_position += (Vector2(0,1 * speed * delta))

func handle_x_sway(delta):
	pass

func handle_y_movement(delta):
	var current_y = enemy_node.global_position.y
	var diff = target_y - current_y

	# Move toward the target at a constant speed
	if abs(diff) > threshold:
		var step = y_speed * delta
		if abs(diff) < step:
			current_y = target_y  # Snap directly if within one step
		else:
			current_y += step * sign(diff)
		enemy_node.global_position.y = current_y
	# When we're close enough to target_y, choose a new target.
	if abs(enemy_node.global_position.y - target_y) < threshold:
		var new_target = randf_range(min_y, max_y)
		# Ensure the new target is at least min_target_distance away.
		while abs(new_target - enemy_node.global_position.y) < min_target_distance:
			new_target = randf_range(min_y, max_y)
		target_y = new_target
