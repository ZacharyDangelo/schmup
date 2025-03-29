extends Node2D

signal on_killed(points: int)

@export var sprite: Texture2D
@export var has_weapon: bool = true
@export_group("Stats")
@export var health: int
@export var points: int
@export_group("FX")
@export var explosion_particles: PackedScene = preload("res://particles/explosion_new.tscn")
@export_group("SFX")
@export var on_hit_sound: AudioStream = preload("res://audio/sfx/click.wav")

@onready var animation_player = $AnimationPlayer

var player
var weapon
var awake
var camera
var movement
var hit_box
var current_health
var sprite_node
var is_shaking

func _ready():
	awake = false
	is_shaking = false
	sprite_node = get_node("Sprite")
	weapon = get_node("Weapon")
	sprite_node.texture = sprite
	movement = get_node("Movement")
	hit_box = get_node("HitBox")
	current_health = health
	setup()
	if animation_player and animation_player.has_animation("idle"):
		animation_player.play("idle")


func setup():
	if hit_box:
		hit_box.area_entered.connect(_on_hit_box_area_entered)
	var player_group = get_tree().get_nodes_in_group("Player")
	if not player_group:
		push_error('Cant find player in sine_cannon fire function')
		return
	on_killed.connect(GameData.add_score)
	player = player_group[0]
	camera = get_camera()
	

func _process(delta):
	if not awake:
		return
	if movement and movement.has_method("process"): 
		movement.process(delta)
	handle_out_of_bounds()

func handle_out_of_bounds():
	if camera:
		var camera_rect = camera.get_viewport_rect()  # Get camera's viewport rectangle
		var camera_position = camera.global_position  # Get camera's position
		var screen_left = camera_position.x - camera_rect.size.x / 2  # Left edge of the screen
		var screen_right = camera_position.x + camera_rect.size.x / 2  # Right edge of the screen
		
		if self.global_position.x < screen_left - 100:
			kill(false)

func offset_camera_movement(delta):
	global_position += Vector2(camera.current_scroll_speed * delta, 0)


func _on_hit_box_area_entered(area: Area2D):
	if not awake:
		return
	take_damage()
	
func take_damage():
	current_health -= 1
	shake()
	SFXManager.play(on_hit_sound)
	if current_health <= 0:
		kill(true)

func kill(score: bool):
	if score:
		on_killed.emit(points)
		spawn_explosion()
	queue_free()
	
func spawn_explosion():
	if not explosion_particles: 
		return
	var explosion = explosion_particles.instantiate()
	explosion.scale = Vector2(.5,.5)
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)

func shake():
	if is_shaking:
		return
	is_shaking = true
	var tween = create_tween()
	tween.finished.connect(func():is_shaking = false)
	
	var original_local_position = sprite_node.position
	
	# Settings for shake intensity and duration
	var shake_intensity = 5.0  # Adjust as needed
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
#############
### Util
#############

func get_camera():
	var camera_group = get_tree().get_nodes_in_group("Camera")
	if not camera_group:
		push_error('Cant find camera in sine_cannon fire function')
		return
	return camera_group[0]


#############
### Signal Callbacks
#############

func _on_visible_on_screen_notifier_2d_screen_entered():
	awake = true
	if has_weapon and "active" in weapon:
		weapon.active = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	if has_weapon and "active" in weapon:
		weapon.active = false
