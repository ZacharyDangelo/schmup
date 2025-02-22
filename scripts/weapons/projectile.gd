extends Node2D

@export var speed: float
@export var ttl: float
@export var dir: Vector2 = Vector2.RIGHT

func _process(delta):
	position += dir.rotated(rotation) * speed * delta
	ttl -= delta
	if ttl <= 0:
		self.queue_free()


func _on_area_2d_area_entered(area):
	self.queue_free()
