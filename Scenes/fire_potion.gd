extends RigidBody2D

var spawnPos : Vector2
var spawnRot : float
var path = Path2D

var dir : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var speed : float = 300

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 0.5

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	velocity = dir * speed

func _physics_process(delta):
	velocity.y += gravity * delta
	
	var collision = move_and_collide(velocity * delta)
	if not collision: return

func _on_area_2d_body_entered(body):
	print("fire effect")
	if body != get_parent():
		queue_free()
