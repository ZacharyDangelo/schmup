extends Resource
class_name EncounterResource
enum Encounter_Type {NORMAL, ELITE, BOSS}

@export var encounter_scene: PackedScene
@export var time_limit: float = 0.0  # If >0, encounter ends after this time regardless of enemy state
@export var require_kill_all_enemies: bool
@export_group("Not Implemented")
@export var time_before_next_encounter: float
@export var type: Encounter_Type
@export var camera_speed_multiplier: float = 1.0
