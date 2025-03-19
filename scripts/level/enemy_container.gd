extends Node2D
signal on_all_enemies_killed()

@export var end_on_enemies_killed: bool = true
	
	
func _process(delta):
	if end_on_enemies_killed and check_for_enemies_killed():
		on_all_enemies_killed.emit()

func check_for_enemies_killed():
	var level_over = true
	var children = get_children()
	for child in children:
		if child.is_in_group("Formations"):
			continue
		elif child.is_in_group("Enemies"):
			level_over = false
	return level_over
