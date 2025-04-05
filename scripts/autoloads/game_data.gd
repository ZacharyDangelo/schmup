extends Node

signal on_score_changed(new_score: int)
signal on_lives_changed(new_lives: int)
var score: int
var current_level:int = 0
var current_lives:int = 3


func add_score(value: int):
	score += value
	on_score_changed.emit(score)
	
func reset_score():
	score = 0
	on_score_changed.emit(score)
	

func set_level(next_level: int):
	current_level = next_level
	get_tree().reload_current_scene()

func set_lives(next_lives: int):
	current_lives = next_lives
	on_lives_changed.emit(next_lives)
