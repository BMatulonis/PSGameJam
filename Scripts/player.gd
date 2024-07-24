extends CharacterBody2D

signal healthChanged
signal gameOver

@export var shadow_damage : float = 1
@export var speed : float = 150.0
@export var fall_gravity : float = 1200
const JUMP_VELOCITY = -350.0
const JUMP_TIME = 0.2
var timer = 0
var facing_right := true
var using_item := false
var in_shadow := false
var moving := false
var jumping := false
var jump_num = 0
var stats = PlayerStats
var inventory = InventorySystem
var max_health = stats.max_health

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var levelScene = get_tree().get_root().get_node("Level")
@onready var potionScene = load("res://Scenes/shadow_potion.tscn")
@onready var animation_player = %AnimationPlayer
@onready var animation_tree = %AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	self.stats.connect("health_depleted", _on_player_stats_health_depleted)
	animation_tree.active = true

func _physics_process(delta):
	if not is_on_floor():
		timer += delta
		velocity.y += get_gravity(velocity) * delta
	else:
		timer = 0
		jump_num = 0
		jumping = false
		animation_tree.set("parameters/conditions/is_jumping", 0)
		animation_state.travel("idle")
		if !in_shadow and stats.health > 0:
			take_damage(shadow_damage)
		elif in_shadow:
			if stats.health < max_health:
				take_damage(-shadow_damage)

	# handle jumping
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4

	# double jump
	if Input.is_action_just_pressed("jump") and !is_on_floor() and jump_num == 1:
		jump_num += 1
		velocity.y = JUMP_VELOCITY
		animation_state.travel("RESET")
		animation_state.travel("jump")

	if Input.is_action_just_pressed("jump") and (is_on_floor() or timer <= JUMP_TIME) and jump_num < 1:
		timer = JUMP_TIME + 1
		jump_num += 1
		velocity.y = JUMP_VELOCITY
		jumping = true
		animation_tree.set("parameters/conditions/idle", 0)
		animation_tree.set("parameters/conditions/is_moving", 0)
		animation_tree.set("parameters/conditions/is_jumping", 1)
		animation_state.travel("jump")

	var direction = Input.get_axis("left", "right")
	if direction == 1:  # right
		facing_right = true
		$AnimatedSprite2D.flip_h = false
	elif direction == -1:  # left
		facing_right = false
		$AnimatedSprite2D.flip_h = true
	if direction:
		velocity.x = direction * speed
		if !jumping:
			moving = true
			animation_tree.set("parameters/conditions/idle", 0)
			animation_tree.set("parameters/conditions/is_moving", 1)
			animation_state.travel("move")
	else:
		if !jumping:
			moving = false
			animation_tree.set("parameters/conditions/idle", 1)
			animation_tree.set("parameters/conditions/is_moving", 0)
			animation_state.travel("idle")
		velocity.x = move_toward(velocity.x, 0, speed)

	# look up
	if Input.is_action_pressed("up") and is_on_floor() and !moving and !jumping:
		animation_tree.set("parameters/conditions/is_up", 1)
		animation_tree.set("parameters/conditions/idle", 0)
		animation_state.travel("up")
	else:
		animation_tree.set("parameters/conditions/is_up", 0)

	# look down
	if Input.is_action_pressed("down") and is_on_floor() and !moving and !jumping:
		animation_tree.set("parameters/conditions/is_down", 1)
		animation_tree.set("parameters/conditions/idle", 0)
		animation_state.travel("down")
	else:
		animation_tree.set("parameters/conditions/is_down", 0)

	# throw
	if Input.is_action_just_pressed("use_item"):
		if !using_item and inventory.shadowPotions > 0:
			using_item = true
		else:
			using_item = false

	if Input.is_action_just_pressed("throw") and using_item and inventory.shadowPotions > 0:
		throw(global_position.direction_to(get_global_mouse_position()))
		inventory.shadowPotions -= 1
		using_item = false

	move_and_slide()

func get_gravity(vel: Vector2):
	if vel.y < 0:
		return gravity
	return fall_gravity

func take_damage(value):
	var old_health = stats.health
	stats.health -= value
	healthChanged.emit(old_health, stats.health)

func throw(dirThrown):
	var instance = potionScene.instantiate()
	instance.spawnPos = global_position
	instance.dir = dirThrown
	if dirThrown.x >= 0:
		instance.spawnPos.x += 10
	else:
		instance.spawnPos.x -= 10
	instance.spawnPos.y -= 10
	instance.spawnRot = rotation
	levelScene.add_child.call_deferred(instance)
	instance.connect("shadowAdded", _on_area_2d_body_shape_entered)

func _on_player_stats_health_depleted():
	gameOver.emit()
	queue_free()

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell = body.get_coords_for_body_rid(body_rid)
		var data = body.get_cell_tile_data(0, cell)
		if data:
			in_shadow = data.get_custom_data("is_shadow")
