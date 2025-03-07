extends Camera2D

@export var scroll_enabled: bool = true
@export var scroll_speed: float
@export var screen_padding: Vector2

var player
var current_scroll_speed

func _ready():
	if player: 
		player = get_node('%Player')
		player.on_died.connect(stop)
	current_scroll_speed = scroll_speed
	Util.camera = self

func _process(delta):
	if scroll_enabled:
		position += Vector2(current_scroll_speed * delta,0)
	
func reset():
	position_smoothing_enabled = false
	position = Vector2.ZERO
	current_scroll_speed = scroll_speed
	position_smoothing_enabled = true
	
func stop():
	current_scroll_speed = 0

func start_camera():
	current_scroll_speed = scroll_speed
	
