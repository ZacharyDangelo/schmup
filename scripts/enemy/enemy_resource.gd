extends Resource

class_name EnemyConfig  # Allows use in the editor

@export var enemy_scene: PackedScene  # Reference to the enemy scene
@export var health: int = 3
@export var points: int = 10

@export_group("Movement")
@export var amplitude: float = 100  # How far the enemy moves up and down
@export var frequency: float = 1.0  # How fast the enemy oscillates
@export var speed: float = 100  # Forward movement speed
@export var max_distance = 150 # How far can the enemy travel before turning around
@export var movement_delay = 2.5
@export var enabled: bool = true
