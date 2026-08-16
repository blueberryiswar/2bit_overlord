extends Node2D

@export var heroes : Array[PackedScene]
@export var spawnDelay : float = 1.0
@export var pathfinder : Pathfinder
var target = Vector2i(8,8)

func spawn_hero() -> void:
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
	spawn_hero()

func set_target(new_target : Vector2i):
	target = new_target

func set_heroes(new_heroes : Array[PackedScene]):
	heroes = new_heroes
	
func add_hero(hero : PackedScene):
	heroes.append(hero)
