extends Node

signal orbsChanged
signal shadowPotChanged
signal firePotChanged
signal icePotChanged
signal item1Changed
signal item2Changed

enum{
	EMPTY = 0,
	SHADOW = 1,
	FIRE = 2,
	ICE = 3
}

@onready var item1 = SHADOW:
	get:
		return item1
	set(value):
		item1 = value
		item1Changed.emit()

@onready var item2 = FIRE:
	get:
		return item2
	set(value):
		item2 = value
		item2Changed.emit()

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

@onready var firePotions = 4:
	get:
		return firePotions
	set(value):
		firePotions = value
		firePotChanged.emit()

@onready var icePotions = 3:
	get:
		return icePotions
	set(value):
		icePotions = value
		icePotChanged.emit()
