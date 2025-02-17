extends Node2D

@export var speed: float
@export var ttl: float
@export var random_mod: Vector2
@export var min_distance: float

var target_pos: Vector2
var rng:Vector2
var dir:Vector2

func _ready():
	rng = Vector2(randf_range(-random_mod.x, random_mod.x), randf_range(-random_mod.y, random_mod.y))
	dir = global_position.direction_to(target_pos + rng)
	

func _process(delta):
	if not target_pos:
		push_error("Cannon Projectile must be provided a target_pos when insantiated")
		return
	var distance_to_target = global_position.distance_to(target_pos + rng)
	position += dir * speed * delta
	ttl -= delta
	if ttl <= 0:
		self.queue_free()


func _on_area_2d_area_entered(area):
	self.queue_free()
