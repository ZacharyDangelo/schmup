extends "res://scripts/enemy/base_enemy.gd"

enum State { ENTERING, FIGHTING, LEAVING }
@export var weapon_delay: float


var current_weapon_timer
var current_state
func _ready():
	super()
	current_state = State.ENTERING
	current_weapon_timer = 0
	
func _process(delta):
	if current_state == State.ENTERING:
		movement.handle_entering_state(delta)
	elif current_state == State.FIGHTING:
		current_weapon_timer += delta
		if current_weapon_timer >= weapon_delay:
			current_weapon_timer = 0
			weapon.fire()
		if weapon.current_shots >= weapon.max_shots:
			current_state = State.LEAVING
	elif current_state == State.LEAVING:
		movement.handle_leaving_state(delta)
	offset_camera_movement(delta)

func offset_camera_movement(delta):
	global_position += Vector2(camera.current_scroll_speed * delta, 0)
