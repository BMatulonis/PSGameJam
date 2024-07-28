extends Node

signal health_depleted

@export var max_health = 1

@onready var health = max_health:
	get:
		return health
	set(value):
		health = value
		if health <= 0:
			health_depleted.emit()

@onready var in_shop := false

func reset_stats():
	health = max_health
