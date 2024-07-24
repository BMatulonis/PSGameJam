extends AnimatedSprite2D

var inventory = InventorySystem

func _on_orb_absorbed():
	inventory.orbs += 1

func _on_area_2d_body_entered(body):
	if body == get_node("../Player"):
		_on_orb_absorbed()
		queue_free()
