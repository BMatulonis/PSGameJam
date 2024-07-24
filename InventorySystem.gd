extends Node

signal orbsChanged
signal shadowPotChanged

@onready var orbs = 0:
	get:
		return orbs
	set(value):
		orbs = value
		orbsChanged.emit()

@onready var shadowPotions = 5:
	get:
		return shadowPotions
	set(value):
		shadowPotions = value
		shadowPotChanged.emit()
