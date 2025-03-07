extends Node2D


@export var starting_level_index: int = 1
@export var levels: Array[PackedScene]

@onready var player = %Player
@onready var camera = %Camera
@onready var level_over_menu = $"../UI/LevelOverMenu"
@onready var game_over_menu = $"../UI/GameOverMenu"

var current_level_index
func _ready():
	current_level_index = starting_level_index
	spawn_next_level(starting_level_index)

func spawn_next_level(level_index: int):
	if get_child_count() != 0:
		get_child(0).queue_free()
	var new_level = levels[level_index].instantiate()
	new_level.position = Vector2.ZERO
	new_level.get_node("LevelStop").level_stopped.connect(_on_level_over)
	add_child(new_level)

func _on_level_over():
	if current_level_index != len(levels) - 1:
		level_over_menu.show_menu()
	else:
		game_over_menu.show_menu()
		game_over_menu.victory()
	player.stop()
	camera.stop()

func _on_level_over_menu_on_continue_button_pressed():
	current_level_index += 1
	if current_level_index < len(levels):
		player.reset()
		camera.reset()
		spawn_next_level(current_level_index)
	else:
		player.stop()
		camera.stop()
		level_over_menu.show_menu()
