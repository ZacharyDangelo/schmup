extends "res://scripts/powerups/base_power_up.gd"

@export var powerup_duration: float = 10
@export var num_extra_projectiles: int = 3

func _ready():
	super()
func _process(delta):
	super(delta)
	
func on_pickup():
	super()
	var player = Util.get_player()
	player.add_projectile_power_up(num_extra_projectiles,powerup_duration, expire_sound)
	self.queue_free()
