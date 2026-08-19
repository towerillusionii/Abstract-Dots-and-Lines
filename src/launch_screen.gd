class_name LaunchScreen extends Node2D

@onready var _play:Label = $CanvasLayer/Control/Play
@onready var _play_button:TouchScreenButton = $"CanvasLayer/Control/Play/Play Button"
@onready var _title_display:AnimationPlayer = $"Title Display"

var _play_button_active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_play.hide()
	_play_button.released.connect(_play_game)
	
	EventBus.transition_completed.emit()
	
	_title_display.play("start")

func _enable_play_button() -> void:
	_play.show()
	_play_button_active = true

func _play_game() -> void:
	if _play_button_active:
		Transition.go_to(Globals.Scene.PLAYER_CONFIG)
