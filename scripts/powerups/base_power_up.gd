extends Node2D

@export var speed: float = 225
@export var ttl: float = 7.5
@export_group("Audio")
@export var spawn_sound: AudioStream
@export var pickup_sound: AudioStream
@export var expire_sound: AudioStream

@onready var animation_player = $AnimationPlayer


var dir
var camera
var ttl_timer
var despawning
func _ready():
	dir = [-1,1].pick_random()
	ttl_timer = 0
	despawning = false
	animation_player.play('glow')
	SFXManager.play(spawn_sound)

func _process(delta):
	camera = Util.get_camera()
	ttl_timer += delta
	position += Vector2(camera.current_scroll_speed * delta,speed * dir * delta)
	if global_position.y <= camera.get_upper_position_bounds():
		dir *= -1
	elif global_position.y >= camera.get_lower_position_bounds():
		dir *= -1
	if ttl_timer >= (ttl * .5) and not despawning:
		despawning = true
		animation_player.play('despawning')
	if ttl_timer >= ttl:
		self.queue_free()
	

func on_pickup():
	SFXManager.play(pickup_sound)

func _on_area_2d_area_entered(area):
	on_pickup()
