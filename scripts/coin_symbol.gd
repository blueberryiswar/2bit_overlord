extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.gold_changed.connect(_on_coins_changed)
	
func _on_coins_changed(coins):
	play("coin")
