extends AudioStreamPlayer

@export var build_phase : AudioStream
@export var fight_phase : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = build_phase
	play(0.0)
	
	GameManager.build_phase_changed.connect(_on_build_phase)
	
func _on_build_phase(is_build_phase : bool):
	if(is_build_phase):
		stream = build_phase
	else:
		stream = fight_phase
	play(0.0)
	
