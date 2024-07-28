class_name MainMenu
extends Control

@onready var startButton = $MarginContainer/HBoxContainer/VBoxContainer/StartButton as Button
@onready var optionsButton = $MarginContainer/HBoxContainer/VBoxContainer/OptionsButton as Button
@onready var exitButton = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton as Button
@onready var margin_container = $MarginContainer
@onready var options_menu = $OptionsMenu
@onready var startLevel = preload("res://Scenes/Levels/level_1.tscn")

func _ready():
	startButton.button_down.connect(_on_start_pressed)
	optionsButton.button_down.connect(_on_options_pressed)
	exitButton.button_down.connect(_on_exit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_packed(startLevel)

func _on_options_pressed():
	margin_container.visible = false
	options_menu.visible = true

func _on_exit_pressed():
	get_tree().quit()

func _on_options_menu_back_pressed():
	margin_container.visible = true
	options_menu.visible = false
