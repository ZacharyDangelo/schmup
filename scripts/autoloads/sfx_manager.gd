extends Node

var sfx_bus_index: int
var pitch_variation: float = 0.1
var max_instances: int = 10

# Pool of AudioStreamPlayers
var players: Array = []

func _ready():
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	# Pre-create a pool of AudioStreamPlayers
	for i in range(max_instances):
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		players.append(player)

func play(stream: AudioStream):
	# Find a free player
	for player in players:
		if not player.playing:
			# Apply pitch variation
			player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
			player.stream = stream
			player.play()
			return  # Play once and stop
