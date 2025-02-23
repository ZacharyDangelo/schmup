extends Node2D

@export var speed: float


var parent

func _ready():
	parent = get_parent()

func process(delta):
	var dir = Vector2.LEFT
	parent.position += dir * speed * delta
