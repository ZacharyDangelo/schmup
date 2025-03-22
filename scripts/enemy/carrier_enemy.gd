extends "res://scripts/enemy/enemy_spawner.gd"

@export var max_interceptors: int
@onready var interceptor_container = $InterceptorContainer

func _process(delta):
	if get_num_interceptors() >= max_interceptors:
		handle_movement(delta)
		return
	super(delta)

func get_num_interceptors():
	return interceptor_container.get_child_count()
	
func spawn_enemy():
	var enemy_node = enemy.instantiate()
	enemy_node.carrier_node = self
	interceptor_container.add_child(enemy_node)
	spawn_timer = 0
