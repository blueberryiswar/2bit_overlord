extends Node2D

@export var heroes : Array[PackedScene]
@export var spawnDelay : float = 1.0
@export var pathfinder : Pathfinder
var target = Vector2i(8,8)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnHero()

func spawnHero() -> void:
	if(heroes.is_empty()):
		return
		
	var hero_scene = heroes[0]
	var hero = hero_scene.instantiate()
	hero.set_pathfinder(pathfinder)
	add_child(hero)
	hero.global_position = global_position
	hero.start_path_to(target)
	heroes.remove_at(0)
	await get_tree().create_timer(spawnDelay).timeout
	spawnHero()
