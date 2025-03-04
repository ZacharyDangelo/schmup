extends Node2D


@export var starting_level_index: int = 0
@export var levels: Array[PackedScene]

@onready var player = %Player
@onready var camera = %Camera
@onready var ui = %UI

var current_level_index
func _ready():
	current_level_index = starting_level_index
	spawn_next_level(starting_level_index)

func spawn_next_level(level_index: int):
	if get_child(0):
		get_child(0).queue_free()
	var new_level = levels[level_index].instantiate()
	new_level.position = Vector2.ZERO
	new_level.get_node("LevelStop").level_stopped.connect(handle_level_finished)
	add_child(new_level)

func handle_level_finished():
	current_level_index += 1
	if current_level_index < len(levels):
		player.reset_position()
		camera.position = Vector2(0,0)
		spawn_next_level(current_level_index)
	else:
		player.speed = 0
		player.weapon.auto_fire = false
		camera.current_scroll_speed = 0
		ui.get_node("LevelOverMenu").show_menu()
		
