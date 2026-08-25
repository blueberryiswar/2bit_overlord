extends Node

enum BuildType {DIG, SPIKE_TRAP, BALISTA, FIRE, WALL, MIMIC, PORTAL}

signal gold_changed(new_amount: int)
signal level_changed(new_level: int)
signal wave_changed(new_wave: int)
signal build_type_changed(new_buildtype : BuildType)
signal build_phase_changed(state : bool)
signal hero_died
signal hero_escaped


var current_build_type : BuildType = BuildType.DIG
var current_build_cost : int = 1

var level : int = 1 :
	set(value):
		level = value
		level_changed.emit(level)

var wave : int = 1 :
	set(value):
		wave = value
		wave_changed.emit(wave)
		
var build_phase : bool = true :
	set(value):
		build_phase = value
		build_phase_changed.emit(build_phase)

var gold : int = 40 :
	set(value):
		gold = value
		gold_changed.emit(gold)
		
var heroes_escaped : int = 0
var heroes_died : int = 0
		
const GAME_OVER_SCENE := "res://levels/game_over.tscn"

func add_gold(amount: int) -> void:
	gold += amount

func remove_gold(amount: int) -> void:
	gold = max(0, gold - amount)

func can_afford(amount: int) -> bool:
	return gold >= amount

func _on_build_type_switched(build_type: BuildType, build_cost: int) -> void:
	current_build_type = build_type
	current_build_cost = build_cost
	build_type_changed.emit(current_build_type)
	
func next_wave():
	if(gold == 0):
		game_over()
		return
	build_phase = true
	wave += 1

func game_over():
	get_tree().change_scene_to_file(GAME_OVER_SCENE)

func on_hero_died() -> void:
	hero_died.emit()
	heroes_died += 1
	
func on_hero_escaped() -> void:
	hero_escaped.emit()
	heroes_escaped += 1
