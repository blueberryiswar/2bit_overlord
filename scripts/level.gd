extends Node2D

@export var wave1 : Array[PackedScene]
@export var wave2 : Array[PackedScene]
@export var wave3 : Array[PackedScene]
@export var treasure_scene : PackedScene
@export var gold : int = 100
@export var pathfinder : Pathfinder
var coins : int = 10
@export var tile_map : TileMapLayer
const treasure_position : Vector2i = Vector2i(8,8)
var nextTeasure : Vector2i = Vector2i(8,8)
var changeX : bool = true
var treasures : Array = []
var undistributed_coins : int
var wave : int = 1
var build_phase : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins = floori(gold/10)
	undistributed_coins = coins
	distribute_coins()
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_select") and build_phase:
		try_to_start_wave()

func try_to_start_wave() -> void:
	pathfinder.update()
	build_phase = false
	tile_map.set_build_mode(false)
	wave_start()

func wave_start():
	var currentWave = wave1
	var entrances = get_tree().get_nodes_in_group("entrance")
	
	for entrance in entrances:
		entrance.set_heroes(currentWave)
		var target = Vector2i(floori(treasures[0].global_position.x/16), floori(treasures[0].global_position.y/16))
		entrance.set_target(target)
		entrance.spawn_hero()

func distribute_coins():
	if undistributed_coins == 0:
		return
	var treasure = treasure_scene.instantiate()
	undistributed_coins  = treasure.set_coins(coins)
	add_child(treasure)
	tile_map.digIntoWall(nextTeasure)
	treasures.append(treasure)
	treasure.global_position = Vector2(nextTeasure.x * 16, nextTeasure.y * 16)
	distribute_coins()
	
func _on_coin_collected(coins):
	gold += coins * 10
	coins = floor(gold / 10)
	undistributed_coins += coins
	distribute_coins()
	print(coins)
