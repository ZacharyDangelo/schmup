extends "res://scripts/enemy/base_enemy.gd"

var shake_time = 0.0
@export var shake_intensity = 2.5

var sprite_node
func _ready():
	super()
	sprite_node = get_node("Sprite")
	pass
	
func _process(delta):
	if shake_time > 0:
		position += Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		shake_time -= delta  # Decrease shake time
	pass
	
func _on_hit_box_area_entered(area: Area2D):
	take_damage()
	
func take_damage():
	current_health -= 1
	shake()
	if current_health <= 0:
		self.queue_free()
		
func shake():
	var tween = create_tween()
	var original_position = position  # Store original position
	var shake_intensity = 5.0  # How much the enemy shakes
	var shake_duration = 0.1  # How long the shake lasts
	var flash_duration = 0.1  # How long the red flash lasts
	# Flash red
	tween.tween_property(sprite_node, "modulate", Color(1, 0, 0), flash_duration / 2)
	for i in range(4):  # Do multiple small shakes
		var random_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity), 
			randf_range(-shake_intensity, shake_intensity)
		)
		tween.tween_property(self, "position", original_position + random_offset, shake_duration / 4)
	tween.tween_property(self, "position", original_position, shake_duration / 4)  # Return to original position
	tween.tween_property(sprite_node, "modulate", Color(1, 1, 1), flash_duration / 2).set_delay(flash_duration / 2)
