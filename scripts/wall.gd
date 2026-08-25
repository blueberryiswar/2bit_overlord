extends Trap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelEvents.set_solid(global_position)

func remove_trap():
	trap_removed.emit(global_position)
	LevelEvents.remove_solid(global_position)
	queue_free()
