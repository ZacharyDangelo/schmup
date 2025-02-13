extends Node2D

@export var max_speed_x = 5
@export var acceleration_x = 5
@export var deceleration_x = 2.5
@export var turn_speed_x = 0.75

@export var max_speed_y = 5
@export var acceleration_y = 5
@export var deceleration_y = 2.5
@export var friction = 0.1
@export var force_turn = false
@export var turn_speed_y = 0.75

var screen_size
var screen_offset = 40
var last_velocity = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var input_vector = Vector2.ZERO
	# Check if player is at the screen edge
	var at_left_edge = position.x <= 78
	var at_right_edge = position.x >= screen_size.x - 78
	var at_top_edge = position.y <= screen_offset
	var at_bottom_edge = position.y >= screen_size.y - screen_offset
	
	# Get movement input
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	if input_vector != Vector2.ZERO:
		# Normalize input to prevent diagonal boost
		input_vector = input_vector.normalized()

		# If force turn is enabled, reset velocity to new direction
		if force_turn or at_top_edge or at_bottom_edge or at_left_edge or at_right_edge:
			last_velocity = input_vector * last_velocity.length()
		else:
			# Apply turn speed ONLY if acceleration is > 0
			if acceleration_x > 0:
				last_velocity.x = lerp(last_velocity.x, input_vector.x * max_speed_x, turn_speed_x * delta)
			if acceleration_y > 0:
				last_velocity.y = lerp(last_velocity.y, input_vector.y * max_speed_y, turn_speed_y * delta)

		# Prevent acceleration if set to 0
		if acceleration_x > 0:
			last_velocity.x += input_vector.x * acceleration_x * delta
		if acceleration_y > 0:
			last_velocity.y += input_vector.y * acceleration_y * delta
	
	# Apply deceleration separately for X and Y
	if input_vector.x == 0 or at_left_edge or at_right_edge:
		var decel_x = deceleration_x * delta + friction * abs(last_velocity.x) * delta
		last_velocity.x = move_toward(last_velocity.x, 0, decel_x)
	
	if input_vector.y == 0 or at_top_edge or at_bottom_edge:
		var decel_y = deceleration_y * delta + friction * abs(last_velocity.y) * delta
		last_velocity.y = move_toward(last_velocity.y, 0, decel_y)
	
	# Clamp velocity separately for X and Y
	last_velocity.x = clamp(last_velocity.x, -max_speed_x, max_speed_x)
	last_velocity.y = clamp(last_velocity.y, -max_speed_y, max_speed_y)

	# Move the player
	position += last_velocity

	# Clamp position to screen bounds
	position = position.clamp(
		Vector2(78, screen_offset),
		Vector2(screen_size.x - 5, screen_size.y - screen_offset)
	)
