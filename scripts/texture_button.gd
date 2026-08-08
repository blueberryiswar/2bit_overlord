extends TextureButton


signal build_type_switched(build_type : GameManager.BuildType, build_cost : int)

@export var build_type : GameManager.BuildType = GameManager.BuildType.DIG
@export var build_cost : int = 1
@export var text := "Dig"
@export var label_text : Label
@export var label_cost : Label

func _ready() -> void:
	pressed.connect(_on_pressed)
	build_type_switched.connect(GameManager._on_build_type_switched)
	GameManager.build_type_changed.connect(_on_build_type_changed)
	label_text.text = text
	label_cost.text = "%d" % build_cost

func _on_pressed() -> void:
	build_type_switched.emit(build_type, build_cost)

func _on_build_type_changed(current_build_type : GameManager.BuildType) -> void:
	if build_type == current_build_type:
		return
	button_pressed = false
