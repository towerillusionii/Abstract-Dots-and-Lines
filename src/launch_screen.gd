class_name LaunchScreen extends Node2D

@onready var _play:Label = $CanvasLayer/Control/Play
@onready var _play_button:TouchScreenButton = $"CanvasLayer/Control/Play/Play Button"
@onready var _title_display:AnimationPlayer = $"Title Display"

var _play_button_active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_play.hide()
	_play_button.released.connect(_play_game)
	_play_button.pressed.connect( _click_noise )
	
	EventBus.transition_completed.emit()
	
	_title_display.play("start")
	Audio.play_song(Audio.Song.SONG_01)

func _click_noise() -> void:
	Audio.play_effect(Audio.Effect.SELECT)

func _enable_play_button() -> void:
	_play.show()
	_play_button_active = true

func _play_game() -> void:
	if _play_button_active:
		Audio.play_effect(Audio.Effect.DESELECT)
		Transition.go_to(Globals.Scene.PLAYER_CONFIG)
