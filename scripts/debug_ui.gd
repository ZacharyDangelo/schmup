extends CanvasLayer

var player

@export var enabled: bool

# Vertical movement inputs
@export var max_speed_y_input: SpinBox
@export var acceleration_y_input: SpinBox
@export var deceleration_y_input: SpinBox
@export var friction_input: SpinBox
@export var turn_speed_y_input: SpinBox

# Horizontal movement inputs
@export var max_speed_x_input: SpinBox
@export var acceleration_x_input: SpinBox
@export var deceleration_x_input: SpinBox
@export var turn_speed_x_input: SpinBox

@export var force_turn_input: CheckBox

@export var velocity_label: Label
@export var export_button: Button
@export var import_button: Button

func _ready():
	if !enabled:
		return
	player = get_node('%Player')
	

	# Set initial values for vertical movement
	max_speed_y_input.value = player.max_speed_y
	acceleration_y_input.value = player.acceleration_y
	deceleration_y_input.value = player.deceleration_y
	friction_input.value = player.friction
	turn_speed_y_input.value = player.turn_speed_y

	# Set initial values for horizontal movement
	max_speed_x_input.value = player.max_speed_x
	acceleration_x_input.value = player.acceleration_x
	deceleration_x_input.value = player.deceleration_x
	turn_speed_x_input.value = player.turn_speed_x

	# Force turn toggle
	force_turn_input.button_pressed = player.force_turn

	# Connect signals to update player values
	max_speed_y_input.value_changed.connect(_on_max_speed_y_changed)
	acceleration_y_input.value_changed.connect(_on_acceleration_y_changed)
	deceleration_y_input.value_changed.connect(_on_deceleration_y_changed)
	friction_input.value_changed.connect(_on_friction_changed)
	turn_speed_y_input.value_changed.connect(_on_turn_speed_y_changed)

	max_speed_x_input.value_changed.connect(_on_max_speed_x_changed)
	acceleration_x_input.value_changed.connect(_on_acceleration_x_changed)
	deceleration_x_input.value_changed.connect(_on_deceleration_x_changed)
	turn_speed_x_input.value_changed.connect(_on_turn_speed_x_changed)

	force_turn_input.toggled.connect(_on_force_turn_toggled)

func _process(delta):
	if !enabled:
		return
	var format_string = "current velocity: (%s, %s)"
	var x = round(player.last_velocity.x)
	var y = round(player.last_velocity.y)
	velocity_label.text = format_string % [x, y]



func copy_player_settings_to_clipboard():
	var player_settings = {
		"max_speed_x": player.max_speed_x,
		"acceleration_x": player.acceleration_x,
		"deceleration_x": player.deceleration_x,
		"turn_speed_x": player.turn_speed_x,
		"max_speed_y": player.max_speed_y,
		"acceleration_y": player.acceleration_y,
		"deceleration_y": player.deceleration_y,
		"friction": player.friction,
		"force_turn": player.force_turn,
		"turn_speed_y": player.turn_speed_y
	}
	
	# Convert to JSON
	var json_string = JSON.stringify(player_settings, "\t") # Pretty print with tabs
	# Copy to clipboard
	DisplayServer.clipboard_set(json_string)
	print("Player settings copied to clipboard!")

func update_ui_from_player():
	max_speed_x_input.value = player.max_speed_x
	acceleration_x_input.value = player.acceleration_x
	deceleration_x_input.value = player.deceleration_x
	turn_speed_x_input.value = player.turn_speed_x

	max_speed_y_input.value = player.max_speed_y
	acceleration_y_input.value = player.acceleration_y
	deceleration_y_input.value = player.deceleration_y
	friction_input.value = player.friction
	turn_speed_y_input.value = player.turn_speed_y

	force_turn_input.button_pressed = player.force_turn

func import_player_settings_from_clipboard():
	""" Imports player settings from clipboard JSON and updates UI and player. """
	if player == null:
		print("Error: Player not found!")
		return

	var clipboard_text = DisplayServer.clipboard_get()
	var parsed_json = JSON.parse_string(clipboard_text)

	if typeof(parsed_json) != TYPE_DICTIONARY:
		print("Error: Invalid JSON format in clipboard!")
		return
	
	# Update player values
	player.max_speed_x = parsed_json.get("max_speed_x", player.max_speed_x)
	player.acceleration_x = parsed_json.get("acceleration_x", player.acceleration_x)
	player.deceleration_x = parsed_json.get("deceleration_x", player.deceleration_x)
	player.turn_speed_x = parsed_json.get("turn_speed_x", player.turn_speed_x)

	player.max_speed_y = parsed_json.get("max_speed_y", player.max_speed_y)
	player.acceleration_y = parsed_json.get("acceleration_y", player.acceleration_y)
	player.deceleration_y = parsed_json.get("deceleration_y", player.deceleration_y)
	player.friction = parsed_json.get("friction", player.friction)
	player.force_turn = parsed_json.get("force_turn", player.force_turn)
	player.turn_speed_y = parsed_json.get("turn_speed_y", player.turn_speed_y)

	# Update UI inputs to reflect new values
	update_ui_from_player()

	print("Player settings imported from clipboard!")

# Vertical movement update handlers
func _on_max_speed_y_changed(value: float):
	player.max_speed_y = value

func _on_acceleration_y_changed(value: float):
	player.acceleration_y = value

func _on_deceleration_y_changed(value: float):
	player.deceleration_y = value

func _on_friction_changed(value: float):
	player.friction = value

func _on_turn_speed_y_changed(value: float):
	player.turn_speed_y = value

# Horizontal movement update handlers
func _on_max_speed_x_changed(value: float):
	player.max_speed_x = value

func _on_acceleration_x_changed(value: float):
	player.acceleration_x = value

func _on_deceleration_x_changed(value: float):
	player.deceleration_x = value

func _on_turn_speed_x_changed(value: float):
	player.turn_speed_x = value

# Force turn toggle
func _on_force_turn_toggled(pressed: bool):
	player.force_turn = pressed


func _on_export_pressed():
	copy_player_settings_to_clipboard()


func _on_import_pressed():
	import_player_settings_from_clipboard()
