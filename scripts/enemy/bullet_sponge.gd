extends "res://scripts/enemy/base_enemy.gd"

var shake_time = 0.0
@export var shake_intensity = 2.5

func _ready():
	super()
	pass
	
func _process(delta):
	if shake_time > 0:
		position += Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		shake_time -= delta  # Decrease shake time
	pass
