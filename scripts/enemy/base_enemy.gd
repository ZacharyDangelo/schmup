extends Node2D

signal on_killed(points: int)

@export var sprite: Texture2D
@export var has_weapon: bool = true
@export_group("Stats")
@export var health: int
@export var points: int



var player
var weapon
var awake
var camera
var movement
var hit_box
var current_health
var sprite_node

func _ready():
	awake = false
	sprite_node = get_node("Sprite")
	weapon = get_node("Weapon")
	sprite_node.texture = sprite
	movement = get_node("Movement")
	hit_box = get_node("HitBox")
	current_health = health
	setup()


func setup():
	if hit_box:
		hit_box.area_entered.connect(_on_hit_box_area_entered)
	var player_group = get_tree().get_nodes_in_group("Player")
	if not player_group:
		push_error('Cant find player in sine_cannon fire function')
		return
	var ui_group = get_tree().get_nodes_in_group("UI")
	if not ui_group:
		push_error('Cant find UI')
		return
	on_killed.connect(ui_group[0]._on_enemy_killed)
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


func _on_hit_box_area_entered(area: Area2D):
	if not awake:
		return
	take_damage()
	
func take_damage():
	current_health -= 1
	shake()
	if current_health <= 0:
		kill(true)

func kill(score: bool):
	if score:
		on_killed.emit(points)
	queue_free()

func shake():
	var tween = create_tween()
	
	var original_local_position = sprite_node.position
	
	# Settings for shake intensity and duration
	var shake_intensity = 5.0  # Adjust as needed
	var shake_duration = 0.1   # Total duration for the shake sequence
	var flash_duration = 0.1   # Duration for the red flash
	
	tween.tween_property(sprite_node, "modulate", Color(1, 0, 0), flash_duration / 2)
	
	# Create multxiple small shake movements on the sprite's local position
	for i in range(4):
		var random_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		tween.tween_property(sprite_node, "position", original_local_position + random_offset, shake_duration / 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite_node, "position", original_local_position, shake_duration / 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite_node, "modulate", Color(1, 1, 1), flash_duration / 2).set_delay(flash_duration / 2)

func get_camera():
	var camera_group = get_tree().get_nodes_in_group("Camera")
	if not camera_group:
		push_error('Cant find camera in sine_cannon fire function')
		return
	return camera_group[0]


func _on_visible_on_screen_notifier_2d_screen_entered():
	awake = true
	print('waking up:',self.name)
	if has_weapon:
		weapon.active = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	if has_weapon:
		weapon.active = false
