extends Node2D

@export var waves : Array[Wave]
@export var pathfinder : Pathfinder
@export var tile_map : TileMapLayer

var remaining_enemies : int = 99

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_select") and GameManager.build_phase:
		try_to_start_wave()

func try_to_start_wave() -> void:
	pathfinder.update()
	var entrances = get_tree().get_nodes_in_group("entrance")
	var exits = get_tree().get_nodes_in_group("exit")

	if !pathfinder.has_valid_path(tile_map.global_to_grid(entrances[0].global_position), tile_map.POS_CHEST, tile_map.global_to_grid(exits[0].global_position)):
		return
	GameManager.build_phase = false
	wave_start()

func wave_start():
	var currentWave = waves[GameManager.wave - 1]
	var entrances = get_tree().get_nodes_in_group("entrance")
	
	for entrance in entrances:
		entrance.set_heroes(currentWave.enemies)
		remaining_enemies = currentWave.enemies.size()
		var target = tile_map.POS_CHEST
		entrance.set_target(target)
		entrance.spawn_hero()
