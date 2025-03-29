extends Node2D

@export var speed: float
@export var screen_offset: float = 25


var parent
var dir
var camera
var current_speed

func _ready():
	dir = Vector2.LEFT
	parent = get_parent()
	camera = Util.get_camera()
	current_speed = speed

func process(delta):
	camera = Util.get_camera()
	# if we hit left side of screen, change dir to go right
	if parent.global_position.x <= camera.get_left_position_bounds() + screen_offset:
		dir = Vector2.RIGHT
		current_speed = speed + (2 * camera.current_scroll_speed)
	elif parent.global_position.x >= camera.get_right_position_bounds() - screen_offset:
		dir = Vector2.LEFT
		current_speed = speed
	parent.position += dir * current_speed * delta
