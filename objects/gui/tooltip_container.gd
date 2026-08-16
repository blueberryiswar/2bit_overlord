extends CanvasLayer

@onready var tooltip_container : PanelContainer = $TooltipContainer
@onready var title_label : Label = $TooltipContainer/VBoxContainer/TitleLabel
@onready var cost_label : Label = $TooltipContainer/VBoxContainer/CostLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tooltip_container.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if tooltip_container.visible:
		tooltip_container.global_position = tooltip_container.get_global_mouse_position() + Vector2(8.0,8.0)

func display(title: String, cost: int) -> void:
	title_label.text = title
	cost_label.text = str(cost)
	tooltip_container.show()
	
func hide_tooltip() -> void:
	tooltip_container.hide()
