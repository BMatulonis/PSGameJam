extends AnimatedSprite2D

signal potionPickup

var inventory = InventorySystem

func _on_pickup():
	inventory.item1 = 1
	inventory.shadowPotions += 5
	potionPickup.emit()

func _on_area_2d_body_entered(body):
	if body == get_node("../Player"):
		_on_pickup()
		queue_free()
