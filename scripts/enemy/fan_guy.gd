extends "res://scripts/enemy/base_enemy.gd"
signal killed_in_formation(node: Node2D)

@export var speed: float

var start_pos
var target_pos

func _ready():
	super()
	start_pos = self.global_position

func kill(score: bool):
	if score:
		on_killed.emit(points)
	killed_in_formation.emit(self)
