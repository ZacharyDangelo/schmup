extends Node2D

@export var speed: float
@export var ttl: float
@export var dir: Vector2 = Vector2.LEFT

var camera
func _ready():
	camera = Util.get_camera()

func _process(delta):
	follow_camera_movement(delta)
	position += dir * speed * delta
	ttl -= delta
	if ttl <= 0:
		queue_free()

func follow_camera_movement(delta):
	position += Vector2(camera.current_scroll_speed,0) * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	queue_free()
