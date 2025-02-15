extends Node2D
# Base movement script, has the most basic logic but can be extended


func process(delta: float):
	pass


func handle_out_of_bounds(camera: Camera2D):
	if camera: 
		var camera_rect = camera.get_viewport_rect()  # Get camera's viewport rectangle
		var camera_position = camera.global_position  # Get camera's position
		var screen_left = camera_position.x - camera_rect.size.x / 2  # Left edge of the screen
		var screen_right = camera_position.x + camera_rect.size.x / 2  # Right edge of the screen

		if self.global_position.x < screen_left - 50 or self.global_position.x > screen_right + 50:
			get_parent().queue_free()
