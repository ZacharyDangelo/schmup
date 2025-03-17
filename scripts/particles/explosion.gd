extends GPUParticles2D
@export var play_audio: bool = true
@onready var audio_stream = $AudioStreamPlayer2D

func _ready():
	emitting = true
	if not audio_stream:
		return
	if play_audio:
		audio_stream.playing = true


func _on_finished():
	queue_free()
