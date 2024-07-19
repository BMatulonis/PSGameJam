extends CharacterBody2D

@export var speed : float = 150.0
@export var fall_gravity : float = 1200
const JUMP_VELOCITY = -350.0
const JUMP_TIME = 0.2
var timer = 0
var jumping : bool = false
var jump_num = 0

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
		jump_num = 0
		jumping = false
		animation_tree.set("parameters/conditions/idle", 1)
		animation_tree.set("parameters/conditions/is_jumping", 0)
		animation_state.travel("idle")

	# handle jumping
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	# double jump
	if Input.is_action_just_pressed("jump") and !is_on_floor() and jump_num == 1:
		jump_num += 1
		velocity.y = JUMP_VELOCITY
		animation_state.travel("jump")

	if Input.is_action_just_pressed("jump") and (is_on_floor() or timer <= JUMP_TIME) and jump_num < 1:
		timer = JUMP_TIME + 1
		jump_num += 1
		velocity.y = JUMP_VELOCITY
		jumping = true
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
		animation_tree.set("parameters/conditions/idle", 0)
		animation_tree.set("parameters/conditions/is_moving", 1)
		animation_state.travel("move")
	else:
		if jumping == false:
			animation_tree.set("parameters/conditions/idle", 1)
			animation_tree.set("parameters/conditions/is_moving", 0)
			animation_state.travel("idle")
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func get_gravity(velocity: Vector2):
	if velocity.y < 0:
		return gravity
	return fall_gravity
