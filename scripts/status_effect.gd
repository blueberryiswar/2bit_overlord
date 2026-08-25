class_name StatusEffect
extends Resource

@export var name : String = "Effect"
@export var duration : float = 3.0
@export var tick_interval : float = 1.0

func on_tick(target : Node) -> void:
	pass
	
func on_apply(target : Node) -> void:
	pass
	
func on_expire(target : Node) -> void:
	pass
