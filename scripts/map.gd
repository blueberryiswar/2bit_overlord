extends TileMapLayer

const TILE_FLOOR : Vector2i = Vector2i(7,0)
const TILE_CHEST : Vector2i = Vector2i(9,0)
const POS_CHEST : Vector2i = Vector2i(8,8)

@export var trap_scenes : Dictionary[GameManager.BuildType, PackedScene] = {}
@export var treasure_scene : PackedScene

var occupied_spaces : Dictionary = {}
var build_active : bool = false

func _ready() -> void:
	place_treasure()

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and GameManager.build_phase:
		var current_pos = get_local_mouse_position()
		try_to_build(current_pos)
		build_active = true
		
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT and GameManager.build_phase:
		build_active = false

func _process(_delta: float) -> void:
	if build_active and Input.is_action_pressed("build"):
		var current_pos = get_local_mouse_position()
		try_to_build(current_pos)

func try_to_build(current_pos : Vector2):
	# check if within map area
	if current_pos.x < 0 or current_pos.y < 0 or current_pos.y > 255 or current_pos.x > 255:
		return
	if !GameManager.can_afford(GameManager.current_build_cost):
		return
	place_build(global_to_grid(current_pos), GameManager.current_build_type)

func place_build(map_coords: Vector2i, build_type : GameManager.BuildType) -> void:
	if build_type == GameManager.BuildType.DIG:
		if not is_wall(map_coords) or is_solid(map_coords):
			return
		GameManager.remove_gold(GameManager.current_build_cost)
		dig_into_wall(map_coords)
	elif trap_scenes.has(build_type):
		if not can_build_here(map_coords):
			return
		GameManager.remove_gold(GameManager.current_build_cost)
		var trap = trap_scenes[build_type].instantiate()
		trap.global_position = to_global(grid_to_global(map_coords))
		trap.set_tile_map(self)
		get_tree().current_scene.add_child(trap)
		trap.trap_removed.connect(_on_trap_removed)
		set_occupant(map_coords, trap)

func can_build_here(map_coords: Vector2i) -> bool:
	if is_wall(map_coords) or is_occupied(map_coords):
			return false
	return true

func global_to_grid(current_pos : Vector2) -> Vector2i:	
	var x = floor(current_pos.x / tile_set.tile_size.x)
	var y = floor(current_pos.y / tile_set.tile_size.y)
	return Vector2i(x,y)

func grid_to_global(gridPos : Vector2i) -> Vector2:
	var x = gridPos.x * tile_set.tile_size.x
	var y = gridPos.y * tile_set.tile_size.y
	return Vector2(x,y)

func is_wall(gridPos : Vector2i) -> bool:
	var data = get_cell_tile_data(gridPos)
	return data != null and data.get_custom_data("wall")
	
func is_solid(gridPos : Vector2i) -> bool:
	var data = get_cell_tile_data(gridPos)
	return data != null and data.get_custom_data("solid")

func dig_into_wall(gridPos:Vector2i) -> void:
	if is_wall(gridPos) and !is_solid(gridPos):
		set_cell(gridPos, 0, TILE_FLOOR)
	
func place_treasure():	
	var treasure = treasure_scene.instantiate()
	treasure.global_position = to_global(grid_to_global(POS_CHEST))
	get_tree().current_scene.add_child.call_deferred(treasure)
	dig_into_wall(POS_CHEST)
	set_occupant(POS_CHEST, treasure)

func is_occupied(pos: Vector2i) -> bool:
	return occupied_spaces.has(pos)

func get_occupant(pos: Vector2i):
	return occupied_spaces.get(pos)

func set_occupant(pos: Vector2i, occupant: Node) -> void:
	occupied_spaces[pos] = occupant

func clear_occupant(pos: Vector2i) -> void:
	occupied_spaces.erase(pos)
	
func _on_trap_removed(pos: Vector2) -> void:
	clear_occupant(global_to_grid(pos))
