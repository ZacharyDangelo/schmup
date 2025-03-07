extends Node

signal on_score_changed(new_score: int)
var score: int


func add_score(value: int):
	score += value
	on_score_changed.emit(score)
	
func reset_score():
	score = 0
	on_score_changed.emit(score)
	
