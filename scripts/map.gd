extends TileMapLayer

const TILE_FLOOR : Vector2i = Vector2i(7,0)
const TILE_CHEST : Vector2i = Vector2i(9,0)
const POS_CHEST : Vector2i = Vector2i(8,8)


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed:
		digIntoWall(globalToGridPos(get_local_mouse_position()))

func globalToGridPos(globalPos : Vector2) -> Vector2i:
	var x = globalPos.x / tile_set.tile_size.x
	var y = globalPos.y / tile_set.tile_size.y
	return Vector2i(x,y)

func gridToGlobalPos(gridPos : Vector2i) -> Vector2:
	var x = gridPos.x * tile_set.tile_size.x
	var y = gridPos.y * tile_set.tile_size.y
	return Vector2(x,y)
	
func isWall(gridPos : Vector2i) -> bool:
	return get_cell_tile_data(gridPos).get_custom_data("wall")

func digIntoWall(gridPos:Vector2i) -> void:
	if isWall(gridPos):
		set_cell(gridPos, 0, TILE_FLOOR)
		
