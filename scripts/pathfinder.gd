class_name Pathfinder
extends Node


var astar_grid
var storages_in_world = []
var manually_solid_points : Array[Vector2i] = []

@export var tile_map : TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	update()
	LevelEvents.make_solid.connect(set_solid)
	LevelEvents.erase_solid.connect(remove_solid)

func get_my_path(start, to):
	var id_path = astar_grid.get_id_path(
		tile_map.local_to_map(start), 
		tile_map.local_to_map(to),
		true
		).slice(1)
	return id_path

func get_my_points(start, to):
	var point_path = astar_grid.get_point_path(
		tile_map.local_to_map(start), 
		tile_map.local_to_map(to),
		true
		).slice(1)
	return point_path

func move_solid(old_position, new_position):
	if(old_position):
		astar_grid.set_point_solid(tile_map.local_to_map(old_position), false)
	astar_grid.set_point_solid(tile_map.local_to_map(new_position))
	
func set_solid(global_pos):
	var local_pos = tile_map.to_local(global_pos)
	var grid_pos = tile_map.local_to_map(local_pos)
	if grid_pos not in manually_solid_points:
		manually_solid_points.append(grid_pos)
	astar_grid.set_point_solid(grid_pos)
	
func remove_solid(global_pos):
	var local_pos = tile_map.to_local(global_pos)
	var grid_pos = tile_map.local_to_map(local_pos)
	manually_solid_points.erase(grid_pos)
	astar_grid.set_point_solid(grid_pos, false)
	
func has_valid_path(entrance: Vector2i, chest: Vector2i, exit: Vector2i) -> bool:
	update()

	if astar_grid.is_point_solid(entrance) or astar_grid.is_point_solid(chest) or astar_grid.is_point_solid(exit):
		return false

	var entrance_to_chest = astar_grid.get_id_path(entrance, chest)
	if entrance_to_chest.is_empty():
		return false

	var chest_to_exit = astar_grid.get_id_path(chest, exit)
	if chest_to_exit.is_empty():
		return false

	return true

func update():
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x
				,y + tile_map.get_used_rect().position.y )
			var ground_data = tile_map.get_cell_tile_data(tile_position)
			
			if ground_data != null and ground_data.get_custom_data("wall"):
				astar_grid.set_point_solid(tile_position)
			else:
				astar_grid.set_point_solid(tile_position, false)
	
	for grid_pos in manually_solid_points:
		astar_grid.set_point_solid(grid_pos)
