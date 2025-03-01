extends Node2D

@export var starting_level_index: int = 0
@export var levels: Array[PackedScene]

func _ready():
	var new_level = levels[starting_level_index].instantiate()
	print('new-level',new_level)
	new_level.position = Vector2.ZERO
	add_child(new_level)
