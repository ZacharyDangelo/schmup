extends ParallaxBackground

var camera

func _ready():
	camera = Util.get_camera()

func _process(delta):
	if not camera:
		camera = Util.get_camera()
	scroll_offset.x -= camera.scroll_speed * delta
	
