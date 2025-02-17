extends Node2D

@export var speed: float
@export var ttl: float


func _process(delta):
	position += Vector2(speed * delta,0)
	ttl -= delta
	if ttl <= 0:
		self.queue_free()


func _on_area_2d_area_entered(area):
	self.queue_free()
