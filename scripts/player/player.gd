extends Node2D

signal on_died()

@export var sprite: Sprite2D
@export var speed: float
@onready var weapon = $Weapon

var start_pos
var screen_size
var screen_offset = 40
var last_velocity = Vector2.ZERO
var camera
var dead
var current_speed

func _ready():
	screen_size = get_viewport_rect().size
	get_node("AnimationPlayer").play("butt_fire")
	camera = get_node('%Camera')
	dead = false
	start_pos = position
	current_speed = speed

func _process(delta):
	if dead:
		return
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
	position += current_speed * input_vector * delta
	
	# Move the player based on camera scroll speed
	position += Vector2(camera.current_scroll_speed * delta,0)
	
	
	# Clamp the players position based on the camera
	var half_screen = get_viewport_rect().size * 0.5 / camera.zoom  # Adjust for zoom
	var min_bounds = (camera.position - camera.offset) - half_screen + camera.screen_padding
	var max_bounds = (camera.position - camera.offset) + half_screen + - camera.screen_padding
	position = position.clamp(min_bounds, max_bounds)

func stop():
	current_speed = 0
	weapon.auto_fire = false

func reset():
	position = start_pos
	current_speed = speed
	weapon.auto_fire = true

func _on_hit_box_area_entered(area):
	dead = true
	on_died.emit()
