extends Node2D

@export var enemy_configs: Array[EnemyConfig]  # Configs now include scene + stats
@export var spawn_delay: float = 0.5  

var spawn_positions: Array
var spawned_enemies: Array

func _ready():
	spawn_positions = get_node("SpawnPositions").get_children()
	spawn_enemies()

func spawn_enemies():
	for i in range(spawn_positions.size()):
		await get_tree().create_timer(spawn_delay * i).timeout  
		var enemy_config = get_enemy_config(i)  
		if enemy_config:
			spawn_enemy(spawn_positions[i].global_position, enemy_config)

func get_enemy_config(index: int) -> EnemyConfig:
	if enemy_configs.is_empty():
		return null  
	return enemy_configs[index % enemy_configs.size()]  

func spawn_enemy(position: Vector2, enemy_config: EnemyConfig):
	if enemy_config.enemy_scene:
		var enemy = enemy_config.enemy_scene.instantiate()
		enemy.global_position = position
		# Apply custom stats
		enemy.health = enemy_config.health
		enemy.speed = enemy_config.speed
		enemy.amplitude = enemy_config.amplitude
		enemy.points = enemy_config.points
		enemy.spawn_pos = position
		enemy.enabled = enemy_config.enabled
		get_node("EnemyContainer").add_child(enemy)
		spawned_enemies.append(enemy)
