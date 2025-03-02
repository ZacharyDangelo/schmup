extends Node2D

@export var speed: float
var parent

func _ready():
	parent = get_parent()

func process(delta):
	var dir = Vector2.LEFT
	var change = speed
	if parent.has_fired:
		change += parent.speed_increase_after_fire
	parent.position += dir * change * delta
