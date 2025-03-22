extends Node

var master_bus_index: int
var sfx_bus_index: int
var music_bus_index: int

func _ready():
	master_bus_index = AudioServer.get_bus_index("Master")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	music_bus_index = AudioServer.get_bus_index("Music")

func _process(delta):
	if Input.is_action_pressed("mute"):
		var is_muted = AudioServer.is_bus_mute(master_bus_index)
		AudioServer.set_bus_mute(master_bus_index,!is_muted)

# Note that this is called from the slider in the options menu.
# Meaning it will pass a value from 0-100
# We must then convert that 0-100 value to a change in decibels
func change_master_volume(value: int):
	var db: float
	if value <= 0:
		db = -200.0  # Mute
	else:
		# Convert the linear slider value (0-100) to decibels.
		# This uses the formula: dB = 20 * log10(value / 100)
		db = 20.0 * log(value / 100.0) / log(10.0)
	AudioServer.set_bus_volume_db(master_bus_index, db)
	
func get_master_volume_linear():
	return AudioServer.get_bus_volume_linear(master_bus_index)

# Note that this is called from the slider in the options menu.
# Meaning it will pass a value from 0-100
# We must then convert that 0-100 value to a change in decibels
func change_sfx_volume(value: int):
	var db: float
	if value <= 0:
		db = -200.0  # Mute
	else:
		# Convert the linear slider value (0-100) to decibels.
		# This uses the formula: dB = 20 * log10(value / 100)
		db = 20.0 * log(value / 100.0) / log(10.0)
	AudioServer.set_bus_volume_db(sfx_bus_index, db)
	
func get_sfx_volume_linear():
	return AudioServer.get_bus_volume_linear(sfx_bus_index)
	
# Note that this is called from the slider in the options menu.
# Meaning it will pass a value from 0-100
# We must then convert that 0-100 value to a change in decibels
func change_music_volume(value: int):
	var db: float
	if value <= 0:
		db = -200.0  # Mute
	else:
		# Convert the linear slider value (0-100) to decibels.
		# This uses the formula: dB = 20 * log10(value / 100)
		db = 20.0 * log(value / 100.0) / log(10.0)
	AudioServer.set_bus_volume_db(music_bus_index, db)

func get_music_volume_linear():
	return AudioServer.get_bus_volume_linear(music_bus_index)
