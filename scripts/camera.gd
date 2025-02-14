extends Camera2D

@export var scroll_speed: float
@export var screen_padding: Vector2

var player

func _ready():
	player = get_node('%Player')

func _process(delta):
	position += Vector2(scroll_speed * delta,0)
	
