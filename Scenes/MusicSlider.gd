extends HSlider

@export var bus_name : String
var bus_index : int

enum {
	MASTER = 0,
	MUSIC = 1,
	SOUND = 2
}

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	#value = db_to_linear(AudioServer.get_bus_volume_db(bus_index)) / 2
	if bus_index == MASTER:
		value = Settings.master_volume
	if bus_index == MUSIC:
		value = Settings.music_volume
	if bus_index == SOUND:
		value = Settings.sound_volume

func _on_value_changed(value : float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	if bus_index == MASTER:
		Settings.master_volume = value
	if bus_index == MUSIC:
		Settings.music_volume = value
	if bus_index == SOUND:
		Settings.sound_volume = value
