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

enum{
	DEFAULT_ORBS = 0,
	DEFAULT_SHADOW = 5,
	DEFAULT_FIRE = 4,
	DEFAULT_ICE = 3
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

@onready var orbs = DEFAULT_ORBS:
	get:
		return orbs
	set(value):
		orbs = value
		orbsChanged.emit()

@onready var shadowPotions = DEFAULT_SHADOW:
	get:
		return shadowPotions
	set(value):
		shadowPotions = value
		shadowPotChanged.emit()

@onready var firePotions = DEFAULT_FIRE:
	get:
		return firePotions
	set(value):
		firePotions = value
		firePotChanged.emit()

@onready var icePotions = DEFAULT_ICE:
	get:
		return icePotions
	set(value):
		icePotions = value
		icePotChanged.emit()

func reset_inventory():
	orbs = DEFAULT_ORBS
	shadowPotions = DEFAULT_SHADOW
	firePotions = DEFAULT_FIRE
	icePotions = DEFAULT_ICE
	item1 = SHADOW
	item2 = FIRE
