extends AnimatedSprite2D

@export var past_checkPoint := false

@onready var collision_shape_2d = $Area2D/CollisionShape2D

var inventory = InventorySystem
var picked_up := false
var new_spawn := false

func _on_orb_absorbed():
	picked_up = true
	inventory.orbs += 1

func _on_area_2d_body_entered(body):
	if body == get_node("../../Player"):
		_on_orb_absorbed()
		self.visible = false
		collision_shape_2d.set_deferred("disabled", true)

func _on_player_respawn():
	if picked_up and new_spawn and !past_checkPoint:
		queue_free()
	else:
		self.visible = true
		collision_shape_2d.set_deferred("disabled", false)

func _on_player_new_spawn():
	new_spawn = true
