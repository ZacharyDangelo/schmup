extends Node2D

var camera

func _process(delta):
	var camera_rect = camera.get_viewport_rect()  # Get camera's viewport rectangle
	var camera_position = camera.global_position  # Get camera's position
	var screen_left = camera_position.x - camera_rect.size.x / 2  # Left edge of the screen
	var screen_right = camera_position.x + camera_rect.size.x / 2  # Right edge of the screen

	if self.global_position.x < screen_left - 50 or self.global_position.x > screen_right + 50:
		self.queue_free()

func _on_hitbox_area_entered(area):
	self.queue_free()
