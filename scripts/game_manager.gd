extends Node

enum BuildType {DIG, SPIKE_TRAP, BALISTA, FIRE, WALL, MIMIC, PORTAL}

signal gold_changed(new_amount: int)
signal level_changed(new_level: int)
signal wave_changed(new_wave: int)
signal build_type_changed(new_buildtype : BuildType)
signal build_phase_changed(state : bool)
		

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
		
const GAME_OVER_SCENE := "res://levels/game_over.tscn"

func add_gold(amount: int) -> void:
	gold += amount

func remove_gold(amount: int) -> void:
	gold = max(0, gold - amount)
	if(gold == 0):
		game_over()

func can_afford(amount: int) -> bool:
	return gold >= amount

func _on_build_type_switched(build_type: BuildType, build_cost: int) -> void:
	current_build_type = build_type
	current_build_cost = build_cost
	build_type_changed.emit(current_build_type)
	
func next_wave():
	build_phase = true
	wave += 1

func game_over():
	get_tree().change_scene_to_file(GAME_OVER_SCENE)
