extends Control

signal on_game_resumed()

@onready var master_slider: HSlider = $PanelContainer/HBoxContainer/MasterSlider
@onready var sfx_slider: HSlider = $PanelContainer/HBoxContainer2/SFXSlider
@onready var music_slider: HSlider = $PanelContainer/HBoxContainer3/MusicSlider


func _ready():
	master_slider.set_value_no_signal(Settings.get_master_volume_linear()  * 100)
	sfx_slider.set_value_no_signal(Settings.get_sfx_volume_linear() * 100)
	music_slider.set_value_no_signal(Settings.get_music_volume_linear() * 100)
	pass
	
func _process(delta):
	pass

func _on_resume_button_pressed() -> void:
	Engine.time_scale = 1
	on_game_resumed.emit()
	self.hide()


func _on_music_slider_value_changed(value: float) -> void:
	Settings.change_music_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	Settings.change_sfx_volume(value)


func _on_master_slider_value_changed(value: float) -> void:
	Settings.change_master_volume(value)
