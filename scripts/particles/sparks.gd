extends Node2D
@onready var gpu_particles_2d = $GPUParticles2D

func _ready():
	gpu_particles_2d.emitting = true
	gpu_particles_2d.connect("finished", func(): self.queue_free())
