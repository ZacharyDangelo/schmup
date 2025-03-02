extends Camera2D

@export var scroll_enabled: bool = true
@export var scroll_speed: float
@export var screen_padding: Vector2

var player
var current_scroll_speed

func _ready():
	player = get_node('%Player')
	player.on_died.connect(stop_camera)
	current_scroll_speed = scroll_speed
	Util.camera = self

func _process(delta):
	if scroll_enabled:
		position += Vector2(current_scroll_speed * delta,0)
	
func stop_camera():
	current_scroll_speed = 0

func start_camera():
	current_scroll_speed = scroll_speed
	
