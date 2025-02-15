extends Node2D

@export var sprite: Texture2D

@export_group("Stats")
@export var health: int
@export var points: int



var camera
var movement

func _ready():
	get_node("Sprite").texture = sprite
	movement = get_node("Movement")

func _process(delta):
	movement.process(delta)
	movement.handle_out_of_bounds(camera)
