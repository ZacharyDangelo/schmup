extends "res://scripts/enemy/base_enemy.gd"

enum State { ENTERING, FIGHTING, LEAVING }
@export var weapon_delay: float

@onready var animation_player = $AnimationPlayer

var current_weapon_timer
var current_state
var dead
func _ready():
	super()
	current_state = State.ENTERING
	current_weapon_timer = 0
	dead = false
	
func _process(delta):
	if current_state == State.ENTERING:
		movement.handle_entering_state(delta)
	elif current_state == State.FIGHTING:
		movement.handle_fighting_state(delta)
		current_weapon_timer += delta
		if current_weapon_timer >= weapon_delay:
			current_weapon_timer = 0
			weapon.fire()
		if weapon.current_shots >= weapon.max_shots:
			current_state = State.LEAVING
	elif current_state == State.LEAVING:
		movement.handle_leaving_state(delta)
	offset_camera_movement(delta)

func kill(score: bool):
	if score and not dead:
		on_killed.emit(points)
	dead = true
	animation_player.play("Death")
	
