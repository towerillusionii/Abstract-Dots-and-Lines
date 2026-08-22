extends Control

@onready var _options_rect:ColorRect = $"Options Rect"

@onready var _quit_button:TouchScreenButton = $"MarginContainer/Quit Label/Quit Button"
@onready var _yes_button:TouchScreenButton  = $"Options Rect/Yes/Yes Button"
@onready var _no_button:TouchScreenButton   = $"Options Rect/No/No Button"

var _options_enabled:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hide_options()
	_quit_button.pressed.connect(_play_click_sound)
	_quit_button.released.connect(_show_options)
	_yes_button.pressed.connect(_play_click_sound)
	_yes_button.released.connect(_go_to_main_menu)
	_no_button.pressed.connect(_play_click_sound)
	_no_button.released.connect(_hide_options_if_enabled)

func _play_click_sound() -> void:
	Audio.play_effect(Audio.Effect.SELECT)

func _hide_options() -> void:
	_options_enabled = false
	_options_rect.hide()
	_options_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _hide_options_if_enabled() -> void:
	if _options_enabled:
		Audio.play_effect(Audio.Effect.DESELECT)
		get_viewport().set_input_as_handled()
		_hide_options()
	
func _show_options() -> void:
	Audio.play_effect(Audio.Effect.DESELECT)
	_options_enabled = true
	_options_rect.show()
	_options_rect.mouse_filter = Control.MOUSE_FILTER_STOP

func _go_to_main_menu() -> void:
	if _options_enabled:
		Audio.play_effect(Audio.Effect.DESELECT)
		Transition.go_to(Globals.Scene.LAUNCH_SCREEN)
