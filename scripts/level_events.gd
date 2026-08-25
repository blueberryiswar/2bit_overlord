extends Node

signal make_solid(position : Vector2)
signal erase_solid(position : Vector2)

func set_solid(position : Vector2) -> void:
	make_solid.emit(position)
	
func remove_solid(position: Vector2) -> void:
	erase_solid.emit(position)
