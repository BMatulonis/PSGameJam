extends RigidBody2D

signal shadowAdded(body_rid, body, body_shape_index, local_shape_index)
signal potionSplash
signal enemyHit

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

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var cell = body.get_coords_for_body_rid(body_rid)
		var data = body.get_cell_tile_data(0, cell)
		if data:
			if !data.get_custom_data("is_shadow"):
				#change from light to shadow
				var atlas = body.get_cell_atlas_coords(0, cell)
				atlas.x -= 7
				body.set_cell(0, cell, 0, atlas)
				shadowAdded.emit(body_rid, body, body_shape_index, local_shape_index)
				#check neighbors
				check_neighbors(body, cell, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
				check_neighbors(body, cell, TileSet.CELL_NEIGHBOR_LEFT_SIDE)

	if body != get_parent():
		if body is CharacterBody2D:
			enemyHit.emit()
			body.queue_free()
		potionSplash.emit()
		queue_free()

func check_neighbors(body : TileMap, cell : Vector2i, side : int):
	var neighbor = body.get_neighbor_cell(cell, side)
	var nData = body.get_cell_tile_data(0, neighbor)
	if nData:
		if !nData.get_custom_data("is_shadow"):
			var neighbor_atlas = body.get_cell_atlas_coords(0, neighbor)
			neighbor_atlas.x -= 7
			body.set_cell(0, neighbor, 0, neighbor_atlas)
