extends Node2D

@export var speed: float
@export var speed_mod: float


func _process(delta):
	position += Vector2(speed * delta,0)
