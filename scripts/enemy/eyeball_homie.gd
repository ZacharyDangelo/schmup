extends "res://scripts/enemy/base_enemy.gd"

@export var lock_on_time: float = 2.4
@export var attack_delay: float = 1.2
@export_group("Movement")
@export var movement_speed: float = 750
@export var locked_on_movement_speed: float = 1000
@export var movement_offset_x: float = 200
@export var movement_offset_y: float = 50

enum State {MOVING, LOCKING_ON, ATTACKING, NONE}
var state
var movement_target_pos
var current_timer = 0 
var locked_on_pos
var animation_player

func _ready():
	super()
	state = State.MOVING
	movement_target_pos = null
	animation_player = get_node("AnimationPlayer")
	pass
	
func _process(delta):
	if not awake:
		return
	if state == State.MOVING:
		handle_moving_state(delta)
	if state == State.LOCKING_ON:
		handle_locking_on_state(delta)
	if state == State.ATTACKING:
		handle_attacking_state(delta)
	offset_camera_movement(delta)
		
func handle_moving_state(delta):
	animation_player.play("RESET")
	if movement_target_pos == null:
		movement_target_pos = get_random_position()
		look_at(movement_target_pos)
		rotation += 160
	global_position = global_position.move_toward(movement_target_pos,movement_speed * delta)
	if global_position == movement_target_pos:
		state = State.LOCKING_ON

func handle_locking_on_state(delta):
	animation_player.play('locking')
	current_timer += delta
	look_at(player.global_position)
	rotation += deg_to_rad(180)
	if current_timer >= lock_on_time:
		locked_on_pos = player.global_position
		state = State.ATTACKING
		current_timer = 0
	
func handle_attacking_state(delta):
	animation_player.play("waiting")
	current_timer += delta
	if current_timer >= attack_delay:
		animation_player.play("attacking")
		var direction = Vector2(cos(rotation), sin(rotation))  # Get forward direction
		position += direction * locked_on_movement_speed * delta * -1  # Move forward
	if global_position.x <= player.global_position.x:
		movement_target_pos = null
		state = State.MOVING

func get_random_position() -> Vector2:
	var camera_rect = camera.get_viewport_rect()  # Get camera viewport size
	var camera_pos = camera.global_position  # Get camera position

	var right_edge_x = camera_pos.x + (camera_rect.size.x / 2) - movement_offset_x  # Just outside right edge
	var min_y = camera_pos.y - (camera_rect.size.y / 2) + movement_offset_y  # Top of visible area + offset
	var max_y = camera_pos.y + (camera_rect.size.y / 2) - movement_offset_y  # Bottom of visible area - offset

	var random_y = randf_range(min_y, max_y)  # Pick a random Y within bounds

	return Vector2(right_edge_x, random_y)
