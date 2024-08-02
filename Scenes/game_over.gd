extends Node2D

@onready var yes_button = $VBoxContainer/HBoxContainer/YesButton as Button
@onready var no_button = $VBoxContainer/HBoxContainer/NoButton as Button

func _on_yes_button_button_down():
	# reload current level scene
	PlayerStats.reset_stats()
	get_tree().change_scene_to_file(PlayerStats.current_level)

func _on_no_button_button_down():
	PlayerStats.reset_stats()
	InventorySystem.reset_inventory()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
