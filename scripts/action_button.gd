class_name ActionButton

extends TextureButton


signal build_type_switched(build_type : GameManager.BuildType, build_cost : int)

@export var build_type : GameManager.BuildType = GameManager.BuildType.DIG
@export var build_cost : int = 1
@export var text := "Dig"
@export var buttonColumn : int = 2
@export var buttonRow : int = 0

func _ready() -> void:
	if texture_normal:
		texture_normal = texture_normal.duplicate()
	if texture_pressed:
		texture_pressed = texture_pressed.duplicate()
	(texture_normal as AtlasTexture).region = Rect2(16.0 * buttonColumn, 16.0 * buttonRow, 16.0, 16.0)
	(texture_pressed as AtlasTexture).region = Rect2(16.0 * (buttonColumn + 1), 16.0 * buttonRow, 16.0, 16.0)
	pressed.connect(_on_pressed)
	build_type_switched.connect(GameManager._on_build_type_switched)
	GameManager.build_type_changed.connect(_on_build_type_changed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_pressed() -> void:
	build_type_switched.emit(build_type, build_cost)

func _on_build_type_changed(current_build_type : GameManager.BuildType) -> void:
	if build_type == current_build_type:
		return
	button_pressed = false

func _on_mouse_entered() -> void:
	TooltipManager.show_tooltip(text, build_cost)
	
func _on_mouse_exited() -> void:
	TooltipManager.hide_tooltip()
