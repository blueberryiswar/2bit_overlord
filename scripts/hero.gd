extends CharacterBody2D

@export var pathfinder : Pathfinder
@export var tile_map : TileMapLayer
@export var health : int = 1
@export var coins : int = 1
@export var steals_amount : int = 2
var wait = false
var goal = Vector2i(8,8)
var lastPosition : Vector2i
var remains_scene = preload("res://objects/remains.tscn")
var thief = false

const SPEED : float = 15.0
var path_queue = []

func start_path_to(goal_map_pos: Vector2i):
	var local_start = tile_map.to_local(global_position)
	var local_goal = tile_map.map_to_local(goal_map_pos)
	if(lastPosition):
		local_start = tile_map.to_local(lastPosition)
	var points = pathfinder.get_my_points(local_start, local_goal)
	path_queue.clear()
	for p in points:
		path_queue.append(tile_map.to_global(p))
	print(path_queue)

func _physics_process(delta):
	if path_queue.is_empty():
		return

	var target = path_queue[0]
	if target.x > global_position.x:
		$Sprite2D.flip_h = true
	elif target.x < global_position.x:
		$Sprite2D.flip_h = false
	global_position = global_position.move_toward(target, SPEED * delta)
	if global_position.distance_to(target) < 1.0:
		lastPosition = target
		path_queue.remove_at(0)

func set_pathfinder(new_pathfinder : Pathfinder) -> void:
	pathfinder = new_pathfinder
	tile_map = new_pathfinder.tile_map
	
func loot(new_coins: int, from_chest: bool):
	coins += new_coins
	if from_chest:
		GameManager.remove_gold(new_coins)

func go_to_exit():
	thief = true
	loot(steals_amount, true)
	var exits = get_tree().get_nodes_in_group("exit")
	var nearest_exit = exits[0]

	# look through exits to see if any are closer
	for exit in exits:
		if exit.global_position.distance_to(global_position) < nearest_exit.global_position.distance_to(global_position):
			nearest_exit = exit

	start_path_to(Vector2i(floor(nearest_exit.global_position.x / 16), floor(nearest_exit.global_position.y / 16)))

func take_damage(damage : int):
	health -= damage
	if health <= 0:
		die()

func escaped():
	queue_free()

func die():
	var remains = remains_scene.instantiate()
	remains.set_coin_value(coins)
	get_tree().current_scene.add_child(remains)
	remains.global_position = global_position
	queue_free()
