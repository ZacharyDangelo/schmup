extends Node

static var camera
static var player

static func get_camera():
	return camera

static func get_player():
	return player

static func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
