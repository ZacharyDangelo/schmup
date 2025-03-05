extends Node2D

@export var speed: float
@export var dir: Vector2


func process(delta):
	get_parent().global_position += speed * dir * delta
