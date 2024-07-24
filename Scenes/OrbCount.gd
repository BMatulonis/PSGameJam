extends RichTextLabel

var inventory = InventorySystem
var count

func _ready():
	inventory.connect("orbsChanged", _on_orbs_changed)
	count = inventory.orbs
	append_text(str(count))

func _on_orbs_changed():
	count = inventory.orbs
	clear()
	append_text(str(count))
