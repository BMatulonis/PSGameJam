extends VBoxContainer

@onready var buy_button = $BuyButton as Button
@onready var mix_button = $MixButton as Button
@onready var leave_button = $LeaveButton as Button
@onready var shop_list_leave = $"../ShopListLeave"
@onready var buy_list = $"../BuyList"

func _ready():
	buy_button.button_down.connect(_buy_pressed)
	leave_button.button_down.connect(_leave_pressed)

func _buy_pressed() -> void:
	self.visible = false
	buy_list.visible = true

func _leave_pressed() -> void:
	self.visible = false
	shop_list_leave.visible = true
