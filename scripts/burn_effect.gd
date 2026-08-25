class_name BurnEffect
extends StatusEffect

@export var damage_per_tick : int = 1

func on_tick(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage_per_tick)
