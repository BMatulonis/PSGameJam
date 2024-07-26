extends TextureRect

enum{
	EMPTY = 0,
	SHADOW = 1,
	FIRE = 2,
	ICE = 3
}

var inventory = InventorySystem

func _ready():
	self.inventory.connect("item1Changed", _on_item_changed)
	if inventory.item1 == SHADOW:
		self.texture = load("res://Assets/Items/potion_1.png")
	elif inventory.item1 == FIRE:
		self.texture = load("res://Assets/Items/potion_2.png")

func _on_item_changed():
	if inventory.item1 == SHADOW:
		self.texture = load("res://Assets/Items/potion_1.png")
	elif inventory.item1 == FIRE:
		self.texture = load("res://Assets/Items/potion_2.png")
