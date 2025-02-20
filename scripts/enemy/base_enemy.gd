extends Node2D

@export var sprite: Texture2D

@export_group("Stats")
@export var health: int
@export var points: int


var player
var camera
var movement
var hit_box
var current_health

func _ready():
	get_node("Sprite").texture = sprite
	movement = get_node("Movement")
	hit_box = get_node("HitBox")
	current_health = health
	
	if hit_box:
		hit_box.area_entered.connect(_on_hit_box_area_entered)
	var player_group = get_tree().get_nodes_in_group("Player")
	if not player_group:
		push_error('Cant find player in sine_cannon fire function')
		return
	player = player_group[0]
	var camera_group = get_tree().get_nodes_in_group("Camera")
	if not camera_group:
		push_error('Cant find camera in sine_cannon fire function')
		return
	camera = camera_group[0]

func _process(delta):
	if movement: 
		movement.process(delta)
	handle_out_of_bounds()
		
func handle_out_of_bounds():
	if camera: 
		var camera_rect = camera.get_viewport_rect()  # Get camera's viewport rectangle
		var camera_position = camera.global_position  # Get camera's position
		var screen_left = camera_position.x - camera_rect.size.x / 2  # Left edge of the screen
		var screen_right = camera_position.x + camera_rect.size.x / 2  # Right edge of the screen

		if self.global_position.x < screen_left - 50 or self.global_position.x > screen_right + 50:
			self.queue_free()


func _on_hit_box_area_entered(area: Area2D):
	take_damage()
	
func take_damage():
	current_health -= 1
	if current_health <= 0:
		self.queue_free()
