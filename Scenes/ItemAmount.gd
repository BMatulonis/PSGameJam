extends RichTextLabel

var inventory = InventorySystem
var count

func _ready():
	inventory.connect("shadowPotChanged", _on_item_changed)
	count = inventory.shadowPotions
	append_text(str(count))

func _on_item_changed():
	count = inventory.shadowPotions
	clear()
	append_text(str(count))
