extends Node

var tooltip_scene : PackedScene = preload("res://objects/gui/tooltip.tscn")
var current_tooltip : Node

func _ready() -> void:
	current_tooltip = tooltip_scene.instantiate()
	get_tree().root.call_deferred("add_child", current_tooltip)
	
func show_tooltip(title: String, cost: int) -> void:
	if current_tooltip:
		current_tooltip.display(title, cost)
		
func hide_tooltip() -> void:
	if current_tooltip:
		current_tooltip.tooltip_container.hide()
