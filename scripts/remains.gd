extends Area2D

signal collected_coin(coins)

@export var coin_value : int = 1
var level

func _ready():
	$AnimatedSprite2D.play("knight")
	input_event.connect(_on_input_event)
	var level_manager = get_tree().get_nodes_in_group("level")
	level = level_manager[0]
	collected_coin.connect(level._on_coin_collected)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		collect_coin()
		
func set_coin_value(value : int):
	coin_value = value

func collect_coin():
	# add to player currency, play pickup animation/sound, etc.
	$AnimatedSprite2D.play("looted")
	collected_coin.emit(coin_value)
