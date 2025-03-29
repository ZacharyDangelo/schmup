extends "res://scripts/enemy/enemy_spawner.gd"

@export var max_interceptors: int
@onready var interceptor_container = $InterceptorContainer
@onready var animation_player = $AnimationPlayer

func _process(delta):
	handle_movement(delta)
	if get_num_interceptors() >= max_interceptors:
		return
	spawn_timer += delta
	if spawn_timer >= spawn_delay:
		play_spawn_animation()

func get_num_interceptors():
	return interceptor_container.get_child_count()

func play_spawn_animation():
	animation_player.play("spawning")

func spawn_enemy():
	var enemy_node = enemy.instantiate()
	enemy_node.carrier_node = self
	interceptor_container.add_child(enemy_node)
	spawn_timer = 0
	animation_player.play("closing")
