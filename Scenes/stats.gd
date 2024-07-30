extends Node

signal health_depleted
signal no_lives
signal life_lost

@export var max_health = 1
@export var starting_lives = 3
@export var starting_level = "res://Scenes/Levels/level_1.tscn"

@onready var health = max_health:
	get:
		return health
	set(value):
		health = value
		if health <= 0:
			health_depleted.emit()

@onready var lives = starting_lives:
	get:
		return lives
	set(value):
		lives = value
		if lives <= 0:
			no_lives.emit()
		else:
			life_lost.emit()

@onready var current_level = starting_level:
	get:
		return current_level
	set(value):
		current_level = value

@onready var in_shop := false

func reset_stats():
	health = max_health
	lives = starting_lives
