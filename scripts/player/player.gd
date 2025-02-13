extends Node2D

@export var max_speed = 5
@export var acceleration = 5
@export var deceleration = 2.5
@export var friction = .1
@export var force_turn = false
@export var turn_speed = .75

var screen_size
var screen_offset = 40
var last_velocity = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size


func _process(delta):
	var input_vector = Vector2.ZERO
	# Check if player is at the screen edge
	var at_top_edge = position.y <= screen_offset
	var at_bottom_edge = position.y >= screen_size.y - screen_offset
	
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	
	if input_vector != Vector2.ZERO:
		# If force turn is enabled, we disregard previous velocity on player input
		if force_turn or at_top_edge or at_bottom_edge:
			last_velocity = input_vector.normalized() * last_velocity.length()
		else:
			last_velocity = last_velocity.lerp(input_vector * last_velocity.length(), turn_speed * delta)		# Normalize input_vector so diagonal movement isn’t faster.
		# Prevent acceleration in the direction of a wall
		if at_top_edge and input_vector.y < 0:
			input_vector.y = 0  # Block upward acceleration
		elif at_bottom_edge and input_vector.y > 0:
			input_vector.y = 0  # Block downward acceleration
		# Accelerate in the allowed direction
		last_velocity += input_vector.normalized() * acceleration * delta
		
	# Apply deceleration.
	if (input_vector == Vector2.ZERO or at_bottom_edge or at_top_edge) and last_velocity.length() > 0:
		# Calculate how much to slow down this frame.
		var decel_amount = deceleration * delta
		var friction_amount = friction * last_velocity.length() * delta
		var total_decel = decel_amount + friction_amount
		# Prevent deceleration from overshooting past zero.
		if last_velocity.length() <= total_decel:
			last_velocity = Vector2.ZERO
		else:
			last_velocity -= last_velocity.normalized() * total_decel
	
	# Clamp the velocity so that it does not exceed max_speed.
	last_velocity = last_velocity.clamp(Vector2(0,-max_speed), Vector2(0,max_speed))
	position += last_velocity
	position = position.clamp(
		Vector2(78, screen_offset),
		Vector2(78, screen_size.y - screen_offset)
	)
