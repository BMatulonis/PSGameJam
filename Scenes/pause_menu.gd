extends Control

@onready var resume_button = $MarginContainer/HBoxContainer/VBoxContainer/ResumeButton as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/OptionsButton as Button
@onready var quit_button = $MarginContainer/HBoxContainer/VBoxContainer/QuitButton as Button
@onready var main_menu_button = $MarginContainer/HBoxContainer2/VBoxContainer/MainMenuButton as Button
@onready var exit_button = $MarginContainer/HBoxContainer2/VBoxContainer/ExitButton as Button
@onready var back_button = $MarginContainer/HBoxContainer2/VBoxContainer/BackButton as Button
@onready var h_box_container = $MarginContainer/HBoxContainer
@onready var h_box_container_2 = $MarginContainer/HBoxContainer2
@onready var margin_container = $MarginContainer
@onready var options_menu = $OptionsMenu

var paused := false
var gameOver := false

func _ready():
	resume_button.button_down.connect(on_resume_pressed)
	main_menu_button.button_down.connect(on_main_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	quit_button.button_down.connect(on_quit_pressed)
	back_button.button_down.connect(on_back_pressed)
	self.visible = false

func _process(delta):
	if Input.is_action_just_pressed("pause") and !gameOver:
		if paused:
			get_tree().paused = false
			self.visible = false
			paused = false
		else:
			get_tree().paused = true
			self.visible = true
			paused = true

func on_resume_pressed() -> void:
		get_tree().paused = false
		self.visible = false
		paused = false

func on_quit_pressed() -> void:
	h_box_container.visible = false
	h_box_container_2.visible = true

func on_back_pressed() -> void:
	h_box_container.visible = true
	h_box_container_2.visible = false

func on_main_pressed() -> void:
	PlayerStats.reset_stats()
	InventorySystem.reset_inventory()
	paused = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.visible = true

func on_exit_pressed() -> void:
	get_tree().quit()

func _on_options_menu_back_pressed():
	options_menu.visible = false
	margin_container.visible = true
