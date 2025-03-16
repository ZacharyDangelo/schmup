extends "res://scripts/formations/base_formation.gd"


@export_group("Movement")
@export var distance_before_turning: float = 60
@export var time_before_turning: float = 1.4
@export var backtrack_distance: float = 30
@export var y_drop: float = 20
@export var distance_grace: float = .25

var initial_target_pos
var backtrack_target_pos
var current_timer
func _ready():
	super()
	initial_target_pos = Vector2(self.global_position.x -distance_before_turning, self.global_position.y)
	backtrack_target_pos = Vector2(initial_target_pos.x + backtrack_distance, self.global_position.y + y_drop)
	handle_movement = true
	current_timer = 0
	if handle_movement:
		for enemy in enemies:
			enemy.target_pos = initial_target_pos
			enemy.killed_in_formation.connect(kill_enemy)

func _process(delta):
	super(delta)
	current_timer += delta

func move_enemies(delta):
	for enemy in enemies:
		if not enemy.awake:
			return
		var dir = enemy.global_position.direction_to(enemy.target_pos)
		enemy.position += dir * enemy.speed * delta
		if enemy.global_position.distance_to(enemy.target_pos) <= distance_grace \
		and enemy.global_position.distance_to(initial_target_pos) <= distance_grace:
			enemy.target_pos = Vector2(backtrack_target_pos)
		if enemy.global_position.distance_to(enemy.target_pos) <= distance_grace \
		and enemy.global_position.distance_to(backtrack_target_pos) <= distance_grace:
			enemy.target_pos = Vector2(-999,enemy.global_position.y)
