extends Node2D

@export var damage : int = 2
var used = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		used = true
		$AnimatedSprite2D.play("bloody")
		body.take_damage(damage)
	else:
		$AnimatedSprite2D.play("trap_active")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
