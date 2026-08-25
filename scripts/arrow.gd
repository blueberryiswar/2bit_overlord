extends RigidBody2D

@export var damage : int = 5
@export var speed : float = 300.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = Vector2.UP.rotated(rotation) * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		body.take_damage(damage)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
