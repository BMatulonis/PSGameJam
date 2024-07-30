extends CharacterBody2D

signal healthChanged
signal gameOver
signal respawn
signal newSpawn

enum{
	EMPTY = 0,
	SHADOW = 1,
	FIRE = 2,
	ICE = 3
}

@export var shadow_damage : float = 1
@export var speed : float = 150.0
@export var fall_gravity : float = 1200
@export var spawn_point : Area2D
@export var check_point : Area2D
const JUMP_VELOCITY = -350.0
const JUMP_TIME = 0.2
var timer = 0
var sound_timer = 0
var sound_played := false
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

@onready var levelScene = get_tree().get_root().get_child(0)
@onready var shadowPotion = load("res://Scenes/shadow_potion.tscn")
@onready var firePotion = load("res://Scenes/fire_potion.tscn")
@onready var animation_player = %AnimationPlayer
@onready var animation_tree = %AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var starting_inventory = [inventory.item1, inventory.item2, inventory.orbs, inventory.shadowPotions, inventory.firePotions, inventory.icePotions]
@onready var checkpoint_inventory = [inventory.item1, inventory.item2, inventory.orbs, inventory.shadowPotions, inventory.firePotions, inventory.icePotions]

func _ready():
	self.stats.connect("health_depleted", _on_player_stats_health_depleted)
	self.stats.connect("no_lives", _on_no_lives)
	self.inventory.connect("orbsChanged", _on_orb_changed)
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

	# handle jumping (no jumping in shop)
	if !stats.in_shop:
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = JUMP_VELOCITY / 4

		# double jump
		if Input.is_action_just_pressed("jump") and !is_on_floor() and jump_num == 1:
			$JumpSound.play()
			jump_num += 1
			velocity.y = JUMP_VELOCITY
			animation_state.travel("RESET")
			animation_state.travel("jump")

		if Input.is_action_just_pressed("jump") and (is_on_floor() or timer <= JUMP_TIME) and jump_num < 1:
			$JumpSound.play()
			timer = JUMP_TIME + 1
			jump_num += 1
			velocity.y = JUMP_VELOCITY
			jumping = true
			animation_tree.set("parameters/conditions/idle", 0)
			animation_tree.set("parameters/conditions/is_moving", 0)
			animation_tree.set("parameters/conditions/is_jumping", 1)
			animation_state.travel("jump")

	# movement (if in shop, no movement)
	var direction = Input.get_axis("left", "right")
	if !stats.in_shop:
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

	# selecting item / inventory
	if Input.is_action_just_pressed("change_item"):
		using_item = false
		var temp = inventory.item1
		inventory.item1 = inventory.item2
		inventory.item2 = temp

	# throw
	if Input.is_action_just_pressed("use_item") and get_tree().current_scene.name != "ShopLevel":
		if !using_item and inventory.item1 > 0:
			using_item = true
		else:
			using_item = false

	if Input.is_action_just_pressed("throw") and using_item:
		# check what type of potion is in slot one
		if inventory.item1 == SHADOW and inventory.shadowPotions > 0:
			throw(global_position.direction_to(get_global_mouse_position()), SHADOW)
		if inventory.item1 == FIRE and inventory.firePotions > 0:
			throw(global_position.direction_to(get_global_mouse_position()), FIRE)
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
	if value > 0:
		sound_played = false
		if sound_timer == 0.0:
			$HurtSound.play()
		if sound_timer >= 1.0:
			sound_timer = 0.0
		else:
			sound_timer += 0.03
	if value < 0 and !sound_played:
		$HealSound.play()
		sound_played = true

func throw(dirThrown : Vector2, potion : int):
	var instance
	if potion == SHADOW:
		instance = shadowPotion.instantiate()
		inventory.shadowPotions -= 1
	if potion == FIRE:
		instance = firePotion.instantiate()
		inventory.firePotions -= 1
	instance.spawnPos = global_position
	instance.dir = dirThrown
	if dirThrown.x >= 0:
		instance.spawnPos.x += 15
	else:
		instance.spawnPos.x -= 15
	instance.spawnPos.y -= 10
	instance.spawnRot = rotation
	levelScene.add_child.call_deferred(instance)
	instance.connect("potionSplash", _on_potion_splash)
	if potion == SHADOW:
		instance.connect("shadowAdded", _on_area_2d_body_shape_entered)

func _on_potion_splash():
	$PotionSplash.play()

func _on_player_stats_health_depleted():
	stats.lives -= 1
	self.global_position = spawn_point.position
	inventory.item1 = checkpoint_inventory[0]
	inventory.item2 = checkpoint_inventory[1]
	inventory.orbs = checkpoint_inventory[2]
	inventory.shadowPotions = checkpoint_inventory[3]
	inventory.firePotions = checkpoint_inventory[4]
	inventory.icePotions = checkpoint_inventory[5]
	respawn.emit()

func _on_no_lives():
	inventory.item1 = starting_inventory[0]
	inventory.item2 = starting_inventory[1]
	inventory.orbs = starting_inventory[2]
	inventory.shadowPotions = starting_inventory[3]
	inventory.firePotions = starting_inventory[4]
	inventory.icePotions = starting_inventory[5]
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/game_over.tscn")

func _on_orb_changed():
	if (inventory.orbs - inventory.old_orbs) > 0:
		$PickupSound.play()
	else:
		$BuySound.play()
	inventory.old_orbs = inventory.orbs

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell = body.get_coords_for_body_rid(body_rid)
		var data = body.get_cell_tile_data(0, cell)
		if data:
			in_shadow = data.get_custom_data("is_shadow")

func _on_floating_potion_potion_pickup():
	$PickupSound.play()

func _on_check_point_body_entered(body):
	if body == self and spawn_point != check_point:
		spawn_point = check_point
		checkpoint_inventory = [inventory.item1, inventory.item2, inventory.orbs, inventory.shadowPotions, inventory.firePotions, inventory.icePotions]
		newSpawn.emit()
