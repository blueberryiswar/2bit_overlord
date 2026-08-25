extends Trap

@export var arrow_scene : PackedScene
@export var cooldown : float = 5.0
var current_cooldown : float = 0
const DIRECTIONS := {
	Vector2i(0, -1): 0.0,           # up
	Vector2i(1, 0): PI / 2,         # right
	Vector2i(0, 1): PI,             # down
	Vector2i(-1, 0): -PI / 2,       # left
}

func _process(delta: float) -> void:
	if current_cooldown > 0:
		current_cooldown -= delta

func shoot() -> void:
	var arrow = arrow_scene.instantiate()
	arrow.global_position = $Pivot/ShootPoint.global_position
	arrow.rotation = $Pivot/ShootPoint.global_rotation
	get_tree().current_scene.add_child(arrow)

func trigger_entered(body: Node2D):
	if(current_cooldown > 0 or !body.is_in_group("hero")):
		return
	current_cooldown = cooldown
	$Pivot/AnimatedSprite2D.play("trap_active")
	
func trap_action():
	shoot()

func adjust_trap_rotation() -> void:
	var map_pos = tile_map.local_to_map(tile_map.to_local(global_position))
	var best_dir := Vector2i(0, -1)
	var best_length := -1

	for dir in DIRECTIONS.keys():
		var length = corridor_length(map_pos, dir)
		if length > best_length:
			best_length = length
			best_dir = dir

	trap_rotation(DIRECTIONS[best_dir])
	
func trap_rotation(new_rotation : float):
	$Pivot.rotation = new_rotation

func corridor_length(start: Vector2i, dir: Vector2i) -> int:
	var length := 0
	var pos := start + dir
	while true:
		var data = tile_map.get_cell_tile_data(pos)
		if data == null or data.get_custom_data("wall"):
			break
		length += 1
		pos += dir
	return length
