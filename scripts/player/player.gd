extends Node2D

signal on_died()
signal on_life_lost()

@export var sprite: Sprite2D
@export var speed: float
@export var max_lives: int = 3
@export var respawn_time: float = 1.6
@export var grace_period_time: float = .5
@onready var weapon = $Weapon
@onready var sfx = $SFX
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $HitBox/CollisionShape2D


var start_pos
var screen_size
var screen_offset = 40
var last_velocity = Vector2.ZERO
var camera
var respawning
var dead
var current_speed
var current_grace_period_timer
var last_trail_point: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	animation_player.play("butt_fire")
	camera = get_node('%Camera')
	dead = false
	respawning = false
	start_pos = position
	current_speed = speed
	current_grace_period_timer = 999
	sprite.material.set("shader_parameter/width",0)
	Util.player = self

func _process(delta):
	current_grace_period_timer += delta
	# Move the player based on camera scroll speed
	position += Vector2(camera.current_scroll_speed * delta,0)
	if not dead:
		var input_vector = Vector2.ZERO
		# Get movement input
		if Input.is_action_pressed("move_down"):
			input_vector.y += 1
		if Input.is_action_pressed("move_up"):
			input_vector.y -= 1
		if Input.is_action_pressed("move_left"):
			input_vector.x -= 1
		if Input.is_action_pressed("move_right"):
			input_vector.x += 1
		
		if input_vector != Vector2.ZERO:
			# Normalize input to prevent diagonal boost
			input_vector = input_vector.normalized()

		# Move the player based on input
		position += current_speed * input_vector * delta
	
	# Play shader respawn effect
	if respawning:
		var shader_width_delta = (10 / respawn_time) * delta
		var curr_width = sprite.material.get("shader_parameter/width")
		sprite.material.set("shader_parameter/width",curr_width - shader_width_delta)
	# Clamp the players position based on the camera
	var half_screen = get_viewport_rect().size * 0.5 / camera.zoom  # Adjust for zoom
	var min_bounds = (camera.position - camera.offset) - half_screen + camera.screen_padding
	var max_bounds = (camera.position - camera.offset) + half_screen + - camera.screen_padding
	position = position.clamp(min_bounds, max_bounds)

func stop():
	current_speed = 0
	weapon.auto_fire = false

func reset():
	respawning = false
	sprite.material.set("shader_parameter/width",0)
	position = start_pos
	current_speed = speed
	current_grace_period_timer = 0
	var timer = get_node("Respawn_timer")
	animation_player.play("butt_fire")
	if timer:
		timer.queue_free()
	
func respawn():
	weapon.auto_fire = false
	sprite.material.set("shader_parameter/width",10)
	
	# Respawn Timer
	var timer = Timer.new()
	timer.name = "Respawn_timer"
	add_child(timer)
	timer.wait_time = respawn_time
	timer.connect("timeout",_on_respawn_finished)
	timer.start()
	respawning = true 
	
func add_projectile_power_up(num_extra_projectiles: int,powerup_duration: float, expire_sound: AudioStream):
	var starting_projectile_count = weapon.spread_projectile_count
	weapon.spread_projectile_count += num_extra_projectiles
	# Powerup Timer
	var timer = Timer.new()
	timer.name = "Powerup_timer"
	add_child(timer)
	timer.wait_time = powerup_duration
	timer.connect("timeout",func(): weapon.spread_projectile_count = starting_projectile_count)
	timer.connect("timeout", func(): SFXManager.play(expire_sound))
	timer.connect("timeout", func(): timer.queue_free())
	timer.start()

#############
### Util
#############

func get_center_position():
	# If the collision shape is correctly centered, no need to add an offset.
	return collision_shape_2d.global_position


#############
### Signal Callbacks
#############
	
func _on_respawn_finished():
	var timer = get_node("Respawn_timer")
	if timer:
		timer.queue_free()
	respawning = false
	sprite.material.set("shader_material/width",0)
	current_grace_period_timer = 0
	animation_player.play("butt_fire")

func _on_hit_box_area_entered(area):
	if respawning or current_grace_period_timer <= grace_period_time:
		return
	GameData.current_lives -= 1
	if GameData.current_lives == 0:
		sfx.play_death_sound()
		dead = true
		animation_player.play("death")
		on_died.emit()
		camera.stop()
	else:
		sfx.play_hit_sound()
		on_life_lost.emit()
		respawn()
		
		
