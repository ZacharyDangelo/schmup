extends "res://scripts/enemy/base_enemy.gd"

@export var rotation_speed: float = 400


func _ready():
	super()

func _process(delta):
	rotation += (deg_to_rad(rotation_speed) * delta)
	super(delta)
