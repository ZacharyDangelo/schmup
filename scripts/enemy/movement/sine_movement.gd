extends Node2D

@export var amplitude: float = 100  # How far the enemy moves up and down
@export var frequency: float = 1.0  # How fast the enemy oscillates
@export var speed: float = 100  # Forward movement speed
@export var max_distance = 150 # How far can the enemy travel before turning around


var time_elapsed: float = 0.0  # Keeps track of time
var parent
var spawn_pos: Vector2
var previous_positions: Array = []


var x_tween: Tween
var y_tween: Tween

func _ready():
	parent = get_parent()
	spawn_pos = parent.global_position
	start_sine_wave_tween()  # Start the sine wave movement


func start_sine_wave_tween():
	x_tween = create_tween()
	y_tween = create_tween()
	x_tween.set_loops()
	y_tween.set_loops()
	
	var travel_time = max_distance / speed  # Time to move full distance
	var total_cycle_time = travel_time * 2  # Full round trip time (right + left)

	# Horizontal movement (back and forth)
	x_tween.tween_property(
		parent, "position:x", 
		spawn_pos.x + max_distance, 
		travel_time
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	# Then move from spawn_pos.x + max_distance back to spawn_pos.x in 'travel_time'
	x_tween.tween_property(
		parent, "position:x", 
		spawn_pos.x, 
		travel_time
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	
	# Vertical movement (full sine wave per round trip)
	var quarter_time = travel_time / 2
	
	#  center -> up
	y_tween.tween_property(
		parent, "position:y",
		spawn_pos.y + amplitude,
		quarter_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	#  up -> center
	y_tween.tween_property(
		parent, "position:y",
		spawn_pos.y,
		quarter_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)



func process(delta):
	# Debug stuff
	previous_positions.append(parent.global_position)
	queue_redraw()


func _draw():
	debug()  # Call the debug function

func debug():
	return
	# Draw a path of past positions as a line
	for i in range(previous_positions.size() - 1):
		draw_line(previous_positions[i] - global_position, 
		previous_positions[i + 1] - global_position, 
		Color(255, 0, 0), 2.0)
