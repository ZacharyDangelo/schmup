extends CanvasLayer


var player
var velocity_label

@export var enabled: bool

@export var max_speed_input: SpinBox
@export var acceleration_input: SpinBox
@export var deceleration_input: SpinBox
@export var friction_input: SpinBox
@export var turn_speed_input: SpinBox
@export var force_turn_input: CheckBox

func _ready():
	if(!enabled):
		return
	player = get_node('%Player')
	velocity_label = get_child(0).get_child(0) # gross
	max_speed_input.value = player.max_speed
	acceleration_input.value = player.acceleration
	deceleration_input.value = player.deceleration
	friction_input.value = player.friction
	turn_speed_input.value = player.turn_speed
	force_turn_input.button_pressed = player.force_turn
	
	# Connect signals to update player values
	max_speed_input.value_changed.connect(_on_max_speed_changed)
	acceleration_input.value_changed.connect(_on_acceleration_changed)
	deceleration_input.value_changed.connect(_on_deceleration_changed)
	friction_input.value_changed.connect(_on_friction_changed)
	turn_speed_input.value_changed.connect(_on_turn_speed_changed)
	force_turn_input.toggled.connect(_on_force_turn_toggled)
	
func _process(delta):
	if(!enabled):
		return
	var format_string = "current velocity: (%s,%s)"
	var x = round(player.last_velocity.x)
	var y = round(player.last_velocity.y)
	velocity_label.text = format_string % [x,y]
	
func _on_max_speed_changed(value: float):
	player.max_speed = value

func _on_acceleration_changed(value: float):
	player.acceleration = value

func _on_deceleration_changed(value: float):
	player.deceleration = value

func _on_friction_changed(value: float):
	player.friction = value

func _on_turn_speed_changed(value: float):
	player.turn_speed = value

func _on_force_turn_toggled(pressed: bool):
	player.force_turn = pressed
