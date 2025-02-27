extends Node2D

@export_group("Movement")
@export var distance_before_turning: float = 60
@export var backtrack_distance: float = 30
@export var y_drop: float = 20
@export var distance_grace: float = .25
var enemies: Array

var awake
var start_pos
var initial_target_pos
var backtrack_target_pos
func _ready():
	awake = false
	enemies = get_node("EnemyContainer").get_children()
	start_pos = self.global_position
	initial_target_pos = Vector2(self.global_position.x -distance_before_turning, self.global_position.y)
	backtrack_target_pos = Vector2(self.global_position.x, self.global_position.y + y_drop)
	for enemy in enemies:
		enemy.target_pos = initial_target_pos

func check_enemy_awake(enemy):
	return enemy.awake

func wake_all():
	for enemy in enemies:
		enemy.awake = true
	awake = true

func _process(delta):
	if not awake and enemies.any(check_enemy_awake):
		wake_all()
	move_enemies(delta)

func move_enemies(delta):
	for enemy in enemies:
		var dir = enemy.global_position.direction_to(enemy.target_pos)
		enemy.position += dir * enemy.speed * delta
		if enemy.global_position.distance_to(enemy.target_pos) <= distance_grace \
		and enemy.global_position.distance_to(initial_target_pos) <= distance_grace:
			enemy.target_pos = Vector2(backtrack_target_pos)
		if enemy.global_position.distance_to(enemy.target_pos) <= distance_grace \
		and enemy.global_position.distance_to(backtrack_target_pos) <= distance_grace:
			enemy.target_pos = Vector2(-999,enemy.global_position.y)



func spawn_enemy(position: Vector2, enemy_config: EnemyConfig):
	pass
