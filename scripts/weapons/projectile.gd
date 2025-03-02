extends Node2D

@export var speed: float
@export var ttl: float
@export var dir: Vector2 = Vector2.RIGHT

func _ready():
	var animation_player = get_node("AnimationPlayer")
	print('animation_player')
	if animation_player:
		animation_player.play("laser")

func _process(delta):
	position += dir.rotated(rotation) * speed * delta
	ttl -= delta
	if ttl <= 0:
		kill()

func kill():
	self.queue_free()

func _on_area_2d_area_entered(area):
	kill()


func _on_visible_on_screen_notifier_2d_screen_exited():
	kill()
