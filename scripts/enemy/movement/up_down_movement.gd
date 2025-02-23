extends Node2D

@export var speed: float
@export var offset: float

var y_bounds
var target
var parent
var dir
func _ready():
	parent = get_parent()
	dir = -1
	y_bounds = get_viewport_rect().size.y
	target = Vector2(global_position.x,dir * (y_bounds - offset))

func process(delta):
	parent.position += Vector2(0,dir * speed * delta)
	if dir == -1 and parent.global_position.y <= target.y:
		dir *= -1
		target = Vector2(global_position.x,dir * (y_bounds - offset))
	if dir == 1 and parent.global_position.y >= target.y:
		dir *= -1
		target = Vector2(global_position.x,dir * (y_bounds - offset))
