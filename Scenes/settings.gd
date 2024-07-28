extends Node

@onready var master_volume = 0.5:
	get:
		return master_volume
	set(value):
		master_volume = value

@onready var music_volume = 0.5:
	get:
		return music_volume
	set(value):
		music_volume = value

@onready var sound_volume = 0.5:
	get:
		return sound_volume
	set(value):
		sound_volume = value
