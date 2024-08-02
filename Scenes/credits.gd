extends Node2D

func _on_main_menu_button_button_down():
	PlayerStats.reset_stats()
	InventorySystem.reset_inventory()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
