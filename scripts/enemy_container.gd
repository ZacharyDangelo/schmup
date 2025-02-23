extends Node2D

@export var enemy_scene: PackedScene
@export var num_to_spawn: int
@export var min_offset: Vector2
@export var max_offset: Vector2


var camera
var player

func _ready():
	camera = get_node('%Camera')
	player = get_node('%Player')
	
func _process(delta):
	if(get_children().size() == 0):
		spawn_enemies()
	
func spawn_enemies():
	
	var camera_rect = camera.get_viewport_rect()  
	var camera_position = camera.global_position  
	var half_width = camera_rect.size.x / 2
	var half_height = camera_rect.size.y / 2
		
	# Use camera's global position as the center point of the spawn area
	var camera_center = camera.global_position  

	for i in range(num_to_spawn):
		var enemy = enemy_scene.instantiate()  
		
		# Spawn within the camera's visible area
		var random_x = randf_range(camera_center.x - half_width + min_offset.x, 
								   camera_center.x + half_width + max_offset.x)
		var random_y = randf_range(camera_center.y - half_height + min_offset.y, 
								   camera_center.y + half_height - max_offset.y)
		
		enemy.position = Vector2(random_x, random_y)  
		enemy.camera = camera  # Ensure enemy has a reference to the camera
		self.add_child(enemy)  
