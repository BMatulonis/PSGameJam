extends RichTextLabel

enum{
	EMPTY = 0,
	SHADOW = 1,
	FIRE = 2,
	ICE = 3
}

var inventory = InventorySystem
var count = 0

func _ready():
	inventory.connect("shadowPotChanged", _on_item_changed)
	inventory.connect("firePotChanged", _on_item_changed)
	inventory.connect("item1Changed", _on_item_changed)
	if inventory.item1 == SHADOW:
		count = inventory.shadowPotions
	elif inventory.item1 == FIRE:
		count = inventory.firePotions
	elif inventory.item1 == ICE:
		count = inventory.icePotions
	else:
		count = 0
	append_text(str(count))

func _on_item_changed():
	if inventory.item1 == SHADOW:
		count = inventory.shadowPotions
	elif inventory.item1 == FIRE:
		count = inventory.firePotions
	elif inventory.item1 == ICE:
		count = inventory.icePotions
	else:
		count = 0
	clear()
	append_text(str(count))
