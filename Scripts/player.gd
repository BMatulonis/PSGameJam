extends CharacterBody2D

@export var speed : float = 300.0
@export var fall_gravity : float = 1200
const JUMP_VELOCITY = -400.0
const JUMP_TIME = 0.15
var timer = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player = %AnimationPlayer
@onready var animation_tree = %AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	if not is_on_floor():
		timer += delta
		velocity.y += get_gravity(velocity) * delta
	else:
		timer = 0
		animation_tree.set("parameters/conditions/idle", 1)
		animation_tree.set("parameters/conditions/is_jumping", 0)
		animation_state.travel("idle")

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	if Input.is_action_just_pressed("jump") and (is_on_floor() or timer < JUMP_TIME):
		timer = JUMP_TIME + 1
		velocity.y = JUMP_VELOCITY
		animation_tree.set("parameters/conditions/idle", 0)
		animation_tree.set("parameters/conditions/is_jumping", 1)
		animation_state.travel("jump")

	var direction = Input.get_axis("left", "right")
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	elif direction == -1:
		$AnimatedSprite2D.flip_h = true
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func get_gravity(velocity: Vector2):
	if velocity.y < 0:
		return gravity
	return fall_gravity
