extends Area2D

signal collected_coin(coins)

@export var coin_value : int = 1
var level
var looted = false
 
func _ready():
	$AnimatedSprite2D.play("knight")
	input_event.connect(_on_input_event)
	var level_manager = get_tree().get_nodes_in_group("level")
	level = level_manager[0]
	#collected_coin.connect(level._on_coin_collected)

func _on_input_event(_viewport, event, _shape_idx):
	if looted:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		collect_coin()

func set_coin_value(value : int):
	coin_value = value

func collect_coin():
	if looted:
		return
	looted = true
	$AnimatedSprite2D.play("looted")
	collected_coin.emit(coin_value)
	GameManager.add_gold(coin_value)

func _on_body_entered(body: Node2D) -> void:
	if looted:
		return
	if body.is_in_group("hero"):
		$AnimatedSprite2D.play("looted")
		looted = true
		body.loot(coin_value, false)
