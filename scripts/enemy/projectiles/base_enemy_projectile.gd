extends Node2D

@export var speed: float
@export var ttl: float
@export var dir: Vector2 = Vector2.LEFT


func _process(delta):
	position += dir * speed * delta
	ttl -= delta
	if ttl <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	queue_free()
