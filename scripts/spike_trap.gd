extends Trap

func trap_action():
	if hero:
		hero.take_damage(damage)
	trap_removed.emit(global_position)
	queue_free()
