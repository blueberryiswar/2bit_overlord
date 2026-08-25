extends Trap

func adjust_trap_rotation():
	var map_pos = tile_map.local_to_map(tile_map.to_local(global_position))
	var above = tile_map.get_cell_tile_data(Vector2i(map_pos.x, map_pos.y + 1))
	var below = tile_map.get_cell_tile_data(Vector2i(map_pos.x, map_pos.y - 1))
	if above != null and above.get_custom_data("wall") or below != null and below.get_custom_data("wall"):
		trap_rotation(0)
	else:
		trap_rotation(PI / 2)

func trigger_entered(body: Node2D):
	if body.is_in_group("hero"):
		used = true
		$AnimatedSprite2D.play("bloody")
		hero = body
	else:
		$AnimatedSprite2D.play("trap_active")

func trap_action():
	if hero:
		hero.take_damage(damage)
	remove_trap()
