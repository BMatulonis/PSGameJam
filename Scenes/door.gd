extends AnimatedSprite2D

@export var next_level : String

var in_door = false

func _on_area_2d_body_entered(body):
	if body == get_node("../Player"):
		in_door = true

func _on_area_2d_body_exited(body):
	if body == get_node("../Player"):
		in_door = false

func _input(event):
	if event.is_action_pressed("up") and in_door:
		get_tree().call_deferred("change_scene_to_file", next_level)
		if next_level == "res://Scenes/shop_level.tscn":
			PlayerStats.in_shop = true
		else:
			PlayerStats.in_shop = false
