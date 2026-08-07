extends Node

signal gold_changed(new_amount: int)

var gold : int = 100 :
	set(value):
		gold = value
		gold_changed.emit(gold)

func add_gold(amount: int) -> void:
	gold += amount

func remove_gold(amount: int) -> void:
	gold = max(0, gold - amount)

func can_afford(amount: int) -> bool:
	return gold >= amount
