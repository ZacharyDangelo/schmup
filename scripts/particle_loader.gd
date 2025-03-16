extends Node2D
@onready var sparks_particles = $SparksParticles
@onready var explosion = $Explosion
@onready var explosion_2 = $Explosion2


func _ready():
	explosion.emitting = true
