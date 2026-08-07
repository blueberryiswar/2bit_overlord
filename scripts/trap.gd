extends Node2D

@export var damage : int = 2
@export var tile_map : TileMapLayer
var used = false
var hero

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if tile_map:
		var map_pos = Vector2i(floor(global_position.x) * 16,floor(global_position.y) * 16)
		var above = tile_map.get_cell_tile_data(Vector2i(map_pos.x, map_pos.y + 1))
		var below = tile_map.get_cell_tile_data(Vector2i(map_pos.x, map_pos.y - 1))
		if above != null and above.get_custom_data("wall") or below != null and below.get_custom_data("wall"):
			trap_rotation(0)
		else:
			trap_rotation(PI / 2)

func trap_rotation(new_rotation : float):
	$AnimatedSprite2D.rotate(new_rotation)
	
func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("hero"):
		used = true
		$AnimatedSprite2D.play("bloody")
		hero = body
	else:
		$AnimatedSprite2D.play("trap_active")

func _on_animated_sprite_2d_animation_finished() -> void:
	if hero:
		hero.take_damage(damage)
	queue_free()
