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
		spawn_explosion()
	killed_in_formation.emit(self)

#func turn_towards(pos: Vector2):
	#var tween = create_tween()
	#var dir = (pos - global_position).angle()
	#var current_rotation = rotation
	#var delta = wrapf(dir - current_rotation, -PI, PI)
	#var target_rotation = (current_rotation + delta) * -1
	#tween.tween_property(self, "rotation", target_rotation, .5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
