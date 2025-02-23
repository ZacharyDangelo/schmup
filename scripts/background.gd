extends ParallaxBackground

var camera

func _ready():
	camera = get_camera()

func _process(delta):
	scroll_offset.x -= camera.scroll_speed * delta
	
func get_camera():
	var camera_group = get_tree().get_nodes_in_group("Camera")
	if not camera_group:
		push_error('Cant find camera in sine_cannon fire function')
		return
	return camera_group[0]
