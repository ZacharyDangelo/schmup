extends "res://scripts/enemy/base_enemy.gd"

@export var debug: bool = false

@export_group("Movement")
@export var amplitude: float = 100  # How far the enemy moves up and down
@export var frequency: float = 1.0  # How fast the enemy oscillates
@export var speed: float = 100  # Forward movement speed
@export var max_distance = 150 # How far can the enemy travel before turning around
@export var movement_delay = 2.5
@export var enabled: bool = true


var spawn_pos: Vector2


func _ready():
	super()
	if movement and enabled:
		movement.amplitude = amplitude
		movement.frequency = frequency
		movement.speed = speed
		movement.max_distance = max_distance
		movement.movement_delay = movement_delay
		movement.debug = debug
		movement.spawn_pos = spawn_pos
		# Start the movement behavior if needed
		movement.start()
