extends Node2D
@export var coins : int = 1
const MAX_COINS : int = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.gold_changed.connect(_on_gold_changed)
	coins = GameManager.gold
	
	
func set_coins(new_coins : int) -> int:
	var rest_coins : int = 0
	if new_coins > MAX_COINS:
		coins = MAX_COINS
		rest_coins = new_coins - MAX_COINS
	else:
		coins = new_coins
	return rest_coins
	
func add_coins(new_coins : int) -> int:
	var rest_coins : int = 0
	if coins + new_coins > MAX_COINS:
		coins = MAX_COINS
		rest_coins = coins + new_coins - MAX_COINS
	else:
		coins = new_coins
	return rest_coins

func updateSprite():
	var frame = 9
	if coins < 10:
		frame = frame + coins
	$Sprite2D.frame = frame
	
func steal_coin():
	coins-= 1
	if coins == 0:
		queue_free()
	updateSprite()
	
func _on_gold_changed(new_coins):
	coins = new_coins
	updateSprite()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		if !body.thief:
			steal_coin()
			body.go_to_exit()
