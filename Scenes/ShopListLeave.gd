extends VBoxContainer

signal leaveShop

@onready var yes_button = $YesButton as Button
@onready var no_button = $NoButton as Button
@onready var shop_list = $"../ShopList"

func _ready():
	yes_button.button_down.connect(_yes_pressed)
	no_button.button_down.connect(_no_pressed)

func _yes_pressed() -> void:
	leaveShop.emit()
	self.visible = false
	PlayerStats.in_shop = false

func _no_pressed() -> void:
	self.visible = false
	shop_list.visible = true
