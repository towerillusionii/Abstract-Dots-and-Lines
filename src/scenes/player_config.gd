class_name PlayerConfig extends Node2D

@onready var _title:Label                       = $CanvasLayer/Control/MarginContainer/VBoxContainer/HBoxContainer2/Title
@onready var _back_button:TouchScreenButton     = $"CanvasLayer/Control/MarginContainer2/Back/Back Button"
@onready var _next_button:TouchScreenButton     = $"CanvasLayer/Control/MarginContainer2/Next/Next Button"
@onready var _name_input:LineEdit               = $"CanvasLayer/Control/MarginContainer/VBoxContainer/GridContainer/Name Input"
@onready var _color_input:ColorPickerButton     = $"CanvasLayer/Control/MarginContainer/VBoxContainer/GridContainer/Color Input"
@onready var _avatar_canvas:CustomDrawingTool = $"CanvasLayer/SubViewportContainer/SubViewport/Avatar Canvas"

var _current_player:GameState.Player = GameState.Player.PLAYER_01
var _allow_save_values:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.transition_completed.emit()
	_back_button.pressed.connect(_play_select_sound)
	_back_button.released.connect(_back_action)
	_next_button.pressed.connect(_play_select_sound)
	_next_button.released.connect(_next_action)
	_color_input.color_changed.connect(_change_color)
	_name_input.text_changed.connect(_change_name)
	
	var color_picker:ColorPicker = _color_input.get_picker()
	color_picker.presets_visible = false
	color_picker.can_add_swatches = false
	color_picker.sliders_visible = false
	color_picker.color_modes_visible = false
	
	_set_player_values()

func _play_select_sound() -> void:
	Audio.play_effect(Audio.Effect.SELECT)

func _set_player_values() -> void:
	_avatar_canvas.set_avatar( GameState.get_player_avatar(_current_player) )
		
	_allow_save_values = false
	_title.text        =  "Player 01" if _current_player == GameState.Player.PLAYER_01 else "Player 02"
	_name_input.text   = GameState.get_player_name(_current_player)
	_color_input.color = GameState.get_player_color(_current_player)
	_allow_save_values = true
	
func _back_action() -> void:
	Audio.play_effect(Audio.Effect.DESELECT)
	_avatar_canvas.save_avatar(_current_player)
	
	if _current_player == GameState.Player.PLAYER_01:
		Transition.go_to(Globals.Scene.LAUNCH_SCREEN)
	elif _current_player == GameState.Player.PLAYER_02:
		_current_player = GameState.Player.PLAYER_01
		_set_player_values()

func _next_action() -> void:
	Audio.play_effect(Audio.Effect.DESELECT)
	_avatar_canvas.save_avatar(_current_player)
	
	if _current_player == GameState.Player.PLAYER_01:
		_current_player = GameState.Player.PLAYER_02
		_set_player_values()
	elif _current_player == GameState.Player.PLAYER_02:
		Transition.go_to(Globals.Scene.GAME_BOARD)

func _change_color(color:Color) -> void:
	if _allow_save_values:
		GameState.set_player_color(_current_player, color)

func _change_name(player_name:String) -> void:
	if _allow_save_values:
		GameState.set_player_name(_current_player, player_name)
