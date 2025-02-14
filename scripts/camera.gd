extends Camera2D

@export var scroll_speed: float

var player

func _ready():
	player = get_node('%Player')

func _process(delta):
	offset += Vector2(scroll_speed * delta,0)
	
