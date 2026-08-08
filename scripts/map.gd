extends TileMapLayer

const TILE_FLOOR : Vector2i = Vector2i(7,0)
const TILE_CHEST : Vector2i = Vector2i(9,0)
const POS_CHEST : Vector2i = Vector2i(8,8)

@export var spike_trap : PackedScene


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed and GameManager.build_phase:
		var current_pos = get_local_mouse_position()
		try_to_build(current_pos)

func try_to_build(current_pos : Vector2):
	# check if within map area
	if current_pos.x < 0 or current_pos.y < 0 or current_pos.y > 255 or current_pos.x > 255:
		return
	if !GameManager.can_afford(GameManager.current_build_cost):
		return
	var grid_pos = globalToGridPos(current_pos)
	GameManager.remove_gold(GameManager.current_build_cost)
	digIntoWall(grid_pos)
	if GameManager.current_build_type == GameManager.BuildType.SPIKE_TRAP:
		var trap = spike_trap.instantiate()
		trap.global_position = gridTocurrent_pos(grid_pos)
		get_tree().current_scene.add_child(trap)

func globalToGridPos(current_pos : Vector2) -> Vector2i:	
	var x = current_pos.x / tile_set.tile_size.x
	var y = current_pos.y / tile_set.tile_size.y
	return Vector2i(x,y)

func gridTocurrent_pos(gridPos : Vector2i) -> Vector2:
	var x = gridPos.x * tile_set.tile_size.x
	var y = gridPos.y * tile_set.tile_size.y
	return Vector2(x,y)

func isWall(gridPos : Vector2i) -> bool:
	return get_cell_tile_data(gridPos).get_custom_data("wall")

func digIntoWall(gridPos:Vector2i) -> void:
	if isWall(gridPos):
		set_cell(gridPos, 0, TILE_FLOOR)
