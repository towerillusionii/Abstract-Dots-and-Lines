extends Control

@onready var _name: Label = $ColorRect/Name
@onready var _color_rect:ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.bonus_turn_earned.connect(_show_card)
	hide()
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _show_card() -> void:
	_color_rect.color = GameState.get_active_player_color()
	_name.text = GameState.get_active_player_name()
	show()
	mouse_filter = Control.MOUSE_FILTER_STOP
	await get_tree().create_timer(.75).timeout
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	hide()
	
