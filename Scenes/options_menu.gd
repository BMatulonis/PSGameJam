extends Control

signal backPressed

@onready var back_button = $MarginContainer/VBoxContainer3/BackButton as Button
#@onready var music_volume = $MarginContainer/HBoxContainer/VBoxContainer/MusicVolume as HSlider
#@onready var sound_volume = $MarginContainer/HBoxContainer/VBoxContainer/SoundVolume as HSlider

func _ready():
	#music_volume.drag_ended.connect(music_changed)
	#sound_volume.drag_ended.connect(sound_changed)
	back_button.button_down.connect(back_button_pressed)

func music_changed() -> void:
	pass

func sound_changed() -> void:
	pass

func back_button_pressed():
	backPressed.emit()
