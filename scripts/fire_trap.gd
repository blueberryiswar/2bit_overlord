extends Trap

@export var burn_effect: StatusEffect

func trigger_entered(body: Node2D):
	var receiver = body.get_node_or_null("StatusEffectReceiver")
	if receiver:
		receiver.apply_effect(burn_effect)
