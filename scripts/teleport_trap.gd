extends Trap

var entrance : Node2D

func _ready() -> void:
	var entrances = get_tree().get_nodes_in_group("entrance")
	entrance = entrances[0]

func trigger_entered(body: Node2D):
	if body.is_in_group("hero"):
		used = true
		body.global_position = entrance.global_position
		body.reset_path()
		remove_trap()
		
