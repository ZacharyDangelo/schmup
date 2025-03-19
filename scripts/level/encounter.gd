extends Node2D

signal on_encounter_finished()

enum EncounterState { IDLE, SPAWNING, ACTIVE, OVER}
@onready var enemy_container = $EnemyContainer

@export var time_before_next_encounter: float
@export_group("Not Implemented")
@export var require_kill_all_enemies: bool
@export var time_limit: float 
@export var type: EncounterResource.Encounter_Type
@export var camera_speed_multiplier: float


var state
var current_wait_timer

func _ready():
	state = EncounterState.IDLE
	if require_kill_all_enemies:
		state = EncounterState.ACTIVE
	current_wait_timer = 0
	
func _process(delta):
	handle_common_behavior()
	if state == EncounterState.IDLE:
		handle_idle_state(delta)
	elif state == EncounterState.SPAWNING:
		handle_spawning_state(delta)
	elif state == EncounterState.ACTIVE:
		handle_active_state(delta)


# This function handles any behavior that is shared amongst all states.
func handle_common_behavior():
	pass

# Idle state is when the encounter is waiting to do something such as
# spawning an enemy, or waiting for the time before the next encounter.
# This is the default state.
func handle_idle_state(delta):
	handle_wait(delta,time_limit, EncounterState.OVER)


# Active state is when the encounter is ongoing and blocking. 
# For example, a fight against an elite where the player must kill the elite to
# continue the level.
# TODO: Implement data driven transition flags.
func handle_active_state(delta):
	handle_wait(delta,time_limit, EncounterState.OVER)

# Waits for limit amount of time, then transitions to next_state
func handle_wait(delta,limit, next_state):
	current_wait_timer += delta
	if current_wait_timer >= limit:
		current_wait_timer = 0
		change_state(next_state)

# Spawning state is when the encounter is waiting to spawn enemies.
# For example, an encounter where after X amount of time more enemies spawn.
# TODO: This is not currently implemented or used.
func handle_spawning_state(delta):
	pass
	
# Over state handles any sort of clean up, or transitionary actions.
# This could be extended in child classes, but here will just emit the 
# on_encounter_finished signal and call the cleanup function.
# Unlike other states, this is not called from the _process function.
# This is because we only want to call this once.
func handle_over_state():
	on_encounter_finished.emit()
	cleanup()

func change_state(new_state):
	state = new_state
	# Optionally add state enter logic for the new state
	if state == EncounterState.OVER:
		handle_over_state()

# Handle any required clean up, delete nodes, etc.
# By default this likely doesn't need to do anything.
func cleanup():
	pass

# Load data from EncounterResource
func load_from_resource(encounter_resource: EncounterResource):
	if not encounter_resource:
		printerr("EncounterResource is null!")
		return
	time_before_next_encounter = encounter_resource.time_before_next_encounter
	require_kill_all_enemies = encounter_resource.require_kill_all_enemies
	time_limit = encounter_resource.time_limit
	type = encounter_resource.type
	camera_speed_multiplier = encounter_resource.camera_speed_multiplier
