extends "res://scripts/powerups/base_power_up.gd"

func on_pickup():
	super()
	GameData.set_lives(GameData.current_lives + 1)
