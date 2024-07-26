extends Line2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5
@export var throwSpeed : float = 300
var throwing = false
var inventory = InventorySystem

func _ready():
	self.inventory.connect("item1Changed", _on_item_changed)

func _process(delta):
	if Input.is_action_just_pressed("use_item"):
		throwing = !throwing
	if Input.is_action_pressed("throw"):
		throwing = false
	if throwing:
		show()
		update_trajectory(get_forward_direction(), throwSpeed, delta)
	else:
		clear_points()

func update_trajectory(dir : Vector2, speed : float, delta):
	var max_points = 100
	clear_points()
	var pos : Vector2 = Vector2.ZERO
	if get_forward_direction().x >= 0:
		pos.x += 15
	else:
		pos.x -= 15
	pos.y -= 10
	var vel = dir * speed
	for i in max_points:
		if i > max_points / 16:
			add_point(pos)
		vel.y += gravity * delta
		
		var collision = $TestCollision.move_and_collide(vel * delta, false, true, true)
		if collision:
			break
		
		pos += vel * delta
		$TestCollision.position = pos

func get_forward_direction() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())

func _on_item_changed():
	throwing = false
