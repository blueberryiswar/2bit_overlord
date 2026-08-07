extends Node2D

@export var treasure_scene : PackedScene
@export var coins : int = 40
@export var tile_map : TileMapLayer
const treasure_position : Vector2i = Vector2i(8,8)
var nextTeasure : Vector2i = Vector2i(8,8)
var changeX : bool = true
var treasures : Array = []
var undistributed_coins = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	distribute_coins()

func distribute_coins():
	if undistributed_coins == 0:
		return
	var treasure = treasure_scene.instantiate()
	undistributed_coins  = treasure.set_coins(coins)
	add_child(treasure)
	tile_map.digIntoWall(nextTeasure)
	treasure.global_position = Vector2(nextTeasure.x * 16, nextTeasure.y * 16)
	distribute_coins()
	
