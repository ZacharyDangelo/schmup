extends GPUParticles2D
@onready var audio_stream = $AudioStreamPlayer2D

func _ready():
	emitting = true
	audio_stream.playing = true
	


func _on_finished():
	queue_free()
