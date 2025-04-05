extends Node2D

@export var health: int
@export var speed: int
@export var points :int
@export var enemy: PackedScene
@export var spawn_delay: float
@export var audio_stream: AudioStream = preload("res://audio/sfx/hit_2.wav")
@onready var spawn_point = $SpawnPoint
@onready var sprite_node = $Sprite2D

var current_health
var spawn_timer
var is_shaking

func _ready():
	spawn_timer = spawn_delay / 2
	current_health = health
	is_shaking = false
	
func _process(delta):
	handle_movement(delta)
	spawn_timer += delta
	if spawn_timer >= spawn_delay:
		spawn_enemy()

func handle_movement(delta):
	global_position += Vector2(speed * delta, 0)
	
func spawn_enemy():
	var enemy_node = enemy.instantiate()
	get_tree().get_current_scene().add_child(enemy_node)
	spawn_timer = 0


func _on_area_2d_area_entered(area):
	take_damage()
	if current_health <= 0:
		kill(true)

func take_damage():
	current_health -= 1
	SFXManager.play(audio_stream)
	shake()

func kill(score):
	if score:
		GameData.add_score(points)
	self.queue_free()
	
func shake():
	if is_shaking:
		return
	is_shaking = true
	var tween = create_tween()
	tween.finished.connect(func():is_shaking = false)
	
	var original_local_position = sprite_node.position
	
	# Settings for shake intensity and duration
	var shake_intensity = 2.5  # Adjust as needed
	var shake_duration = 0.1   # Total duration for the shake sequence
	var flash_duration = 0.1   # Duration for the red flash
	
	tween.tween_property(sprite_node, "modulate", Color(1, 0, 0), flash_duration / 2)
	
	# Create multiple small shake movements on the sprite's local position
	for i in range(4):
		var random_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		tween.tween_property(sprite_node, "position", original_local_position + random_offset, shake_duration / 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite_node, "position", original_local_position, shake_duration / 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite_node, "modulate", Color(1, 1, 1), flash_duration / 2).set_delay(flash_duration / 2)
