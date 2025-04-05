extends Node

static var camera
static var player

static func get_camera():
	return camera

static func get_player():
	return player

static func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))

static func is_node_on_screen(node: Node2D) -> bool:
	var node_pos = node.global_position
	return (
		node_pos.x >= camera.get_left_position_bounds() and
		node_pos.x <= camera.get_right_position_bounds() and
		node_pos.y >= camera.get_upper_position_bounds() and
		node_pos.y <= camera.get_lower_position_bounds()
	)
