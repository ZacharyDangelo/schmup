extends "res://scripts/enemy/base_enemy.gd"

func _ready():
	super()
	
	if global_position.y > camera.global_position.y:
		sprite_node.flip_v = false
	else:
		sprite_node.flip_v = true

func _process(delta):
	super(delta)
