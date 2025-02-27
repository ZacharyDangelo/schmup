extends "res://scripts/enemy/base_enemy.gd"
@export var speed: float

var start_pos
var target_pos

func _ready():
	super()
	start_pos = self.global_position
