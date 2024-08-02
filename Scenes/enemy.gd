extends CharacterBody2D

@export var past_checkPoint := false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var alive := true
var new_spawn := false
var facing_right := true
var moving := false
var speed = 50
var timer = 0.0
var timer_speed = 0.01
var rng = RandomNumberGenerator.new()
var random_interval

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var animation_player = $AnimatedSprite2D/AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true
	random_interval = rng.randf_range(1.0, 1.4)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if timer <= random_interval:
			timer += timer_speed
		else:
			timer = 0.0
			random_interval = rng.randf_range(1.0, 1.4)
			if random_interval <= 1.1:
				flip()
			moving = !moving
			if moving:
				animation_tree.set("parameters/conditions/is_moving", 1)
				animation_tree.set("parameters/conditions/idle", 0)
				animation_state.travel("move")
			else:
				animation_tree.set("parameters/conditions/is_moving", 0)
				animation_tree.set("parameters/conditions/idle", 1)
				animation_state.travel("idle")


	if !$RayCast2D.is_colliding() and is_on_floor():
		flip()
	if $RayCast2D2.is_colliding() and is_on_floor():
		flip()


	if moving:
		velocity.x = speed
	else:
		velocity.x = move_toward(velocity.x, 0, abs(speed))

	move_and_slide()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

func _on_area_2d_body_entered(body):
	if body is RigidBody2D:
		#queue_free()
		alive = false
		self.visible = false
		collision_shape_2d.set_deferred("disabled", true)

func _on_player_respawn():
	if !alive and new_spawn and !past_checkPoint:
		queue_free()
	else:
		self.visible = true
		collision_shape_2d.set_deferred("disabled", false)

func _on_player_new_spawn():
	new_spawn = true
