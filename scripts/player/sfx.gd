extends AudioStreamPlayer2D

@export var shoot_stream: AudioStream
@export var hit_stream: AudioStream
@export var death_stream: AudioStream

func play_hit_sound():
	handle_is_playing(hit_stream)
	stream = hit_stream
	play()

func play_death_sound():
	handle_is_playing(death_stream)
	stream = death_stream
	play()

func play_shoot_sound():
	handle_is_playing(shoot_stream)
	stream = shoot_stream
	play()

# Here we can add logic to determine what should happen if a sound is already
# playing, but we try to start playing another sound.
# This behavior can be different depending on which stream is currently playing.
# For example, the shoot sound is low priority and should be cancelled if any
# other sound is queued.
func handle_is_playing(next_stream):
	if playing and next_stream != shoot_stream:
		stop()
	else:
		return
