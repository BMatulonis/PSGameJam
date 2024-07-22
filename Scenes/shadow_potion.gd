extends RigidBody2D

var right : bool
var spawnPos : Vector2
var spawnRot : float

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 0.5

var shadowTexture = load("res://Assets/Tiles/rock_01_shadow.png")

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	if right:
		apply_central_impulse(Vector2(100, -200))
	else:
		apply_central_impulse(Vector2(-100, -200))

func _on_area_2d_body_entered(body):
	if body.has_meta("is_shadow"):
		if !body.get_meta("is_shadow"):
			body.get_node("Sprite2D").texture = shadowTexture
		body.set_meta("is_shadow", true)
	
	if body != get_node("../Player"):
		queue_free()
