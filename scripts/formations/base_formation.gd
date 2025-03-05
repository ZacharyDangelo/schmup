extends Node2D

@export_group("Flags")
@export var wake_all: bool = true
@export var handle_movement: bool = false

var enemies: Array
var awake
var start_pos

func _ready():
	awake = false
	enemies = get_node("EnemyContainer").get_children()
	start_pos = self.global_position

func _process(delta):
	if not awake and wake_all and enemies.any(check_enemy_awake):
		wake_all_enemies()
	if handle_movement:
		move_enemies(delta)

func move_enemies(delta):
	push_warning("Formation should not handle movement unless custom movement behavior has been provided in script.")

func check_enemy_awake(enemy):
	return enemy.awake

func wake_all_enemies():
	for enemy in enemies:
		enemy.awake = true
	awake = true

func kill_enemy(node: Node2D):
	if node in enemies:
		enemies.erase(node)  # Removes the enemy from the array
		node.spawn_explosion()
		node.queue_free()  # Safely removes it from the scene tree
