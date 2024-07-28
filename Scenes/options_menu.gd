extends Control

signal backPressed

@onready var back_button = $MarginContainer/VBoxContainer3/BackButton as Button

func _ready():
	back_button.button_down.connect(back_button_pressed)

func back_button_pressed():
	backPressed.emit()
