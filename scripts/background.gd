extends ParallaxBackground

var camera

func _ready():
	camera = get_node('%Camera')

func _process(delta):
	scroll_offset.x -= camera.scroll_speed * delta
