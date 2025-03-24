extends CanvasLayer
@onready var main = $Main
@onready var options = $Options
@export var main_scene: PackedScene
@export_group("SFX")
@export var play_button_clicked_stream: AudioStream
@export var options_button_clicked_stream: AudioStream


func _on_options_button_pressed():
	SFXManager.play(options_button_clicked_stream)
	main.hide()
	options.show()


func _on_button_pressed():
	SFXManager.play(options_button_clicked_stream)
	main.show()
	options.hide()


func _on_play_button_pressed():
	SFXManager.play(play_button_clicked_stream)
	get_tree().change_scene_to_packed(main_scene)


func _on_music_slider_value_changed(value: float) -> void:
	Settings.change_music_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	Settings.change_sfx_volume(value)


func _on_master_slider_value_changed(value: float) -> void:
	Settings.change_master_volume(value)
