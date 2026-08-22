class_name LaunchScreen extends Node2D

@onready var _play:Label         = $CanvasLayer/Control/Play
@onready var _credit_label:Label = $"CanvasLayer/Credits Container/MarginContainer/ScrollContainer/Label"

@onready var _title_display:AnimationPlayer = $"Title Display"
@onready var _credits_container:MarginContainer = $"CanvasLayer/Credits Container"

@onready var _play_button:TouchScreenButton  = $"CanvasLayer/Control/Play/Play Button"
@onready var _godot_button:TouchScreenButton = $"CanvasLayer/Icons/HBoxContainer/Godot/Godot Button"
@onready var _ti_2_button:TouchScreenButton  = $"CanvasLayer/Icons/HBoxContainer/Tower Illusion/TI2 Button"
@onready var _ofl_button:TouchScreenButton   = $"CanvasLayer/Icons/HBoxContainer/OFL/OFL Button"

@onready var _close_button:TouchScreenButton = $"CanvasLayer/Credits Container/Close Label/Close Button"

var _play_button_active:bool = false

func _ready() -> void:
	_play.hide()
	_credits_container.hide()
	_credits_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	_play_button.released.connect(_play_game)
	_play_button.pressed.connect( _click_noise )
	_godot_button.pressed.connect(_click_noise)
	_godot_button.released.connect(_show_godot_credits)
	_ti_2_button.pressed.connect(_click_noise)
	_ti_2_button.released.connect(_show_ti2_credits)
	_ofl_button.pressed.connect(_click_noise)
	_ofl_button.released.connect(_show_ofl_credits)
	_close_button.pressed.connect(_click_noise)
	_close_button.released.connect(_close_credits)
	
	EventBus.transition_completed.emit()
	
	_title_display.play("start")
	Audio.play_song(Audio.Song.PLAYLIST)

func _close_credits() -> void:
	_play_button_active = true
	Audio.play_effect(Audio.Effect.DESELECT)
	_credits_container.hide()
	_credits_container.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _open_credits() -> void:
	_play_button_active = false
	_credits_container.show()
	_credits_container.mouse_filter = Control.MOUSE_FILTER_PASS

func _show_godot_credits():
	_open_credits()
	Audio.play_effect(Audio.Effect.DESELECT)
	_credit_label.text = License.get_godot_credits()
	
func _show_ti2_credits():
	_open_credits()
	Audio.play_effect(Audio.Effect.DESELECT)
	_credit_label.text = License.get_ti2_credits()

func _show_ofl_credits():
	_open_credits()
	Audio.play_effect(Audio.Effect.DESELECT)
	_credit_label.text = License.get_ofl_credits()

func _click_noise() -> void:
	Audio.play_effect(Audio.Effect.SELECT)

func _enable_play_button() -> void:
	_play.show()
	_play_button_active = true

func _play_game() -> void:
	if _play_button_active:
		Audio.play_effect(Audio.Effect.DESELECT)
		Transition.go_to(Globals.Scene.PLAYER_CONFIG)
