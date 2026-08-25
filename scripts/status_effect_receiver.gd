class_name StatusEffectReceiver
extends Node

var active_effects : Dictionary = {}  # StatusEffect -> {remaining: float, next_tick: float}

func apply_effect(effect: StatusEffect) -> void:
	if active_effects.has(effect):
		active_effects[effect].remaining = effect.duration
		return
	active_effects[effect] = {"remaining": effect.duration, "next_tick": effect.tick_interval}
	effect.on_apply(get_parent())

func get_active_effects() -> Array:
	return active_effects.keys()

func _process(delta: float) -> void:
	var expired : Array = []
	for effect in active_effects.keys():
		var state = active_effects[effect]
		state.remaining -= delta
		state.next_tick -= delta
		if state.next_tick <= 0.0:
			effect.on_tick(get_parent())
			state.next_tick += effect.tick_interval
		if state.remaining <= 0.0:
			expired.append(effect)
	for effect in expired:
		effect.on_expire(get_parent())
		active_effects.erase(effect)
