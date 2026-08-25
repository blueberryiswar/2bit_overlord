class_name Trap
extends Node2D

signal trap_removed(position : Vector2)

@export var damage : int = 2
@export var tile_map : TileMapLayer
var used = false
var hero

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if tile_map:
		adjust_trap_rotation()

func adjust_trap_rotation():
	print("implement adjust rotation")

func trap_rotation(new_rotation : float):
	$AnimatedSprite2D.rotation = new_rotation
	
func trap_action():
	if hero:
		hero.take_damage(damage)
	trap_removed.emit(global_position)
	queue_free()
	
func remove_trap():
	trap_removed.emit(global_position)
	queue_free()
	
func trigger_entered(body: Node2D):
	if body.is_in_group("hero"):
		used = true
		$AnimatedSprite2D.play("bloody")
		hero = body
	else:
		$AnimatedSprite2D.play("trap_active")
	
func _on_trigger_body_entered(body: Node2D) -> void:
	if used:
		return
	trigger_entered(body)

func _on_animated_sprite_2d_animation_finished() -> void:
	trap_action()

func set_tile_map(new_tile_map : TileMapLayer) -> void:
	tile_map = new_tile_map
	adjust_trap_rotation()
