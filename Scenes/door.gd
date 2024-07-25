extends Sprite2D

var in_door = false

func _on_area_2d_body_entered(body):
	in_door = true

func _on_area_2d_body_exited(body):
	in_door = false

func _input(event):
	if event.is_action_pressed("up") and in_door:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/shop_level.tscn")
