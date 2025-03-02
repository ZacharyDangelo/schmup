extends "res://scripts/enemy/base_enemy.gd"

@export var speed_increase_after_fire: float = 45

var has_fired

func _ready():
	super()
	has_fired = false
