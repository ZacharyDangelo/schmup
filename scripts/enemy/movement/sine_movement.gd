extends Node2D

signal peak_reached

@export var amplitude: float = 100  # How far the enemy moves up and down
@export var frequency: float = 1.0  # How fast the enemy oscillates
@export var speed: float = 100  # Forward movement speed
@export var max_distance = 150 # How far can the enemy travel before turning around
@export var movement_delay = 2.5
@export var debug: bool = false


var time_elapsed: float = 0.0  # Keeps track of time
var parent
var spawn_pos: Vector2
var target_pos: Vector2
var previous_positions: Array = []

var x_tween: Tween
var y_tween: Tween
var waiting: bool

var current_movement_delay = 0
var travel_time = max_distance / speed  # Time to move full distance
var total_cycle_time = travel_time * 2  # Full round trip time (right + left)
# Vertical movement (full sine wave per round trip)
var half_time = travel_time / 2
var current_movement_timer = 0
var signaled = false

enum Direction {LEFT, RIGHT}
var dir = Direction.LEFT

func _ready():
	parent = get_parent()
	
	
func start():
	target_pos = Vector2(parent.global_position.x - max_distance, parent.global_position.y + amplitude)
	move_forward()  # Start the sine wave movement

func move_forward():
	waiting = false
	dir = -1
	x_tween = create_tween()
	# Connect signal so we know when this movement has finished
	x_tween.finished.connect(set.bind('waiting',true))
	
	y_tween = create_tween()

	# Horizontal movement (back and forth)
	x_tween.tween_property(
		parent, "position:x", 
		target_pos.x, 
		travel_time
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	#  center -> up/down
	y_tween.tween_property(
		parent, "position:y",
		spawn_pos.y + amplitude,
		half_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	#  up/down -> center
	y_tween.tween_property(
		parent, "position:y",
		spawn_pos.y,
		half_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	

func move_back_to_spawn():
	waiting = false
	x_tween = create_tween()
	# Connect signal so we know when this movement has finished
	x_tween.finished.connect(set.bind('waiting',true))
	y_tween = create_tween()
	# Move from spawn_pos.x + max_distance back to spawn_pos.x in 'travel_time'
	x_tween.tween_property(
		parent, "position:x", 
		spawn_pos.x,
		travel_time
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	# Vertical movement (full sine wave per round trip)
	var half_time = travel_time / 2
		# Return
	# center -> up
	y_tween.tween_property(
		parent, "position:y",
		spawn_pos.y + amplitude,
		half_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	#  up -> center
	y_tween.tween_property(
		parent, "position:y",
		spawn_pos.y,
		half_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func process(delta):
	if waiting:
		current_movement_delay += delta
		if current_movement_delay >= movement_delay:
			if dir == Direction.RIGHT:
				move_forward()
				dir = Direction.LEFT
			else: 
				dir = Direction.RIGHT
				move_back_to_spawn()
			current_movement_delay = 0 
			signaled = false
			current_movement_timer = 0
	if not waiting:
		current_movement_timer += delta
		if current_movement_timer >= half_time and not signaled:
			peak_reached.emit()
			signaled = true
		
	# Debug stuff
	if debug:
		previous_positions.append(parent.global_position)
		queue_redraw()


func _draw():
	if debug: 
		draw_debug()  # Call the debug function

func draw_debug():
	# Draw a path of past positions as a line
	for i in range(previous_positions.size() - 1):
		draw_line(previous_positions[i] - global_position, 
		previous_positions[i + 1] - global_position, 
		Color(255, 0, 0), 2.0)
