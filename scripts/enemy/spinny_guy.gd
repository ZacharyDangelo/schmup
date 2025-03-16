extends "res://scripts/enemy/base_enemy.gd"

@export var rotation_speed: float = 400
@export var spark_particles: PackedScene = preload("res://particles/sparks_particle.tscn")

func _ready():
	super()

func _process(delta):
	rotation += (deg_to_rad(rotation_speed) * delta)
	super(delta)

func take_damage():
	super()
	var particles = spark_particles.instantiate()
	particles.global_position = self.global_position
	particles.scale = Vector2(10,10)
	get_tree().current_scene.add_child(particles)
