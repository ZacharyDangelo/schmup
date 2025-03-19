extends Node2D

enum State {IDLE, RUNNING, SPECIAL, TRANSITION}

@export var levels: Resource
@onready var player = %Player
@onready var camera = %Camera
@onready var level_over_menu = $"../UI/LevelOverMenu"
@onready var game_over_menu = $"../UI/GameOverMenu"

var state

func _ready():
	state = State.IDLE
	
func _process(_delta):
	if state == State.IDLE:
		pass
	elif state == State.RUNNING:
		pass
	elif state == State.SPECIAL:
		pass
	elif state == State.TRANSITION:
		pass
	return
