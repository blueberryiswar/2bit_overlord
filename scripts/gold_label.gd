extends Label

func _ready():
	GameManager.gold_changed.connect(_on_coins_changed)
	text = "%d" % GameManager.gold  # set initial value

func _on_coins_changed(new_amount: int):
	text = "%d" % new_amount
	
