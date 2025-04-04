extends Node2D


@export var levels: Array[PackedScene]
@onready var hud = $"../UI/HUD"
@onready var player = %Player
@onready var camera = %Camera
@onready var level_over_menu = $"../UI/LevelOverMenu"
@onready var game_over_menu = $"../UI/GameOverMenu"

func _ready():
	spawn_level()

func spawn_level():
	var new_level = levels[GameData.current_level].instantiate()
	new_level.position = Vector2.ZERO
	var level_enemies = new_level.get_node("Enemies")
	if level_enemies:
		level_enemies.on_all_enemies_killed.connect(_on_level_over)
	add_child(new_level)
	

func _on_level_over():
	if GameData.current_level != len(levels) - 1:
		level_over_menu.show_menu()
		hud.hide()
	else:
		game_over_menu.show_menu()
		game_over_menu.victory()
	player.stop()
	camera.stop()
