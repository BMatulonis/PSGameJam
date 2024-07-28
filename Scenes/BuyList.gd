extends VBoxContainer

@onready var shadow_button = $ShadowButton as Button
@onready var fire_button = $FireButton as Button
@onready var back_button = $BackButton as Button
@onready var shop_list = $"../ShopList"
@onready var error_sound = $ErrorSound

func _ready():
	shadow_button.button_down.connect(_shadow_pressed)
	fire_button.button_down.connect(_fire_pressed)
	back_button.button_down.connect(_back_pressed)

func _shadow_pressed() -> void:
	if InventorySystem.orbs > 0:
		InventorySystem.orbs -= 1
		InventorySystem.shadowPotions += 1
	else:
		error_sound.play()

func _fire_pressed() -> void:
	if InventorySystem.orbs > 0:
		InventorySystem.orbs -= 1
		InventorySystem.firePotions += 1
	else:
		error_sound.play()

func _back_pressed() -> void:
	self.visible = false
	shop_list.visible = true
