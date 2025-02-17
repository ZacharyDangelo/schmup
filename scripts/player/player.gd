extends Node2D

@export var sprite: Sprite2D
@export var speed: float

var screen_size
var screen_offset = 40
var last_velocity = Vector2.ZERO
var camera

func _ready():
	screen_size = get_viewport_rect().size
	camera = get_node('%Camera')

func _process(delta):
	var input_vector = Vector2.ZERO
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

	# Move the player based on input
	position += speed * input_vector * delta
	
	# Move the player based on camera scroll speed
	position += Vector2(camera.scroll_speed * delta,0)
	
	
	# Clamp the players position based on the camera
	var half_screen = get_viewport_rect().size * 0.5 / camera.zoom  # Adjust for zoom
	var min_bounds = (camera.position - camera.offset) - half_screen + camera.screen_padding
	var max_bounds = (camera.position - camera.offset) + half_screen + - camera.screen_padding
	position = position.clamp(min_bounds, max_bounds)
