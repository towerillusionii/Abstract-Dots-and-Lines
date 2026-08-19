extends Control

@onready var _color_rect:ColorRect = $ColorRect
@onready var _draw_game: Label = $Draw
@onready var _winner_name: Label = $Name
@onready var _won_with: Label = $"won with"
@onready var _count: Label = $count
@onready var _boxes: Label = $boxes
@onready var _avatar:TextureRect = $"Avatar Container/MarginContainer/Avatar"
@onready var _try_again_button:TouchScreenButton = $"Try Again/Try Again Button"
@onready var _try_again_label:Label = $"Try Again"
@onready var _quit_button:TouchScreenButton = $"Quit/Quit Button"
@onready var _quit_label:Label = $Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.game_finished.connect(_show_card)
	_try_again_button.pressed.connect(_try_again_pressed)
	_try_again_button.released.connect(_try_again_released)
	_quit_button.pressed.connect(_quit_button_pressed)
	_quit_button.released.connect(_quit_button_released)
	
	_draw_game.hide()
	_winner_name.hide()
	_won_with.hide()
	_count.hide()
	_boxes.hide()
	_avatar.hide()
	hide()
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _try_again_pressed() -> void:
	_try_again_label.modulate = Color(0.626, 0.626, 0.626, 1.0)

func _try_again_released() -> void:
	_try_again_label.modulate = Color(1.0,1.0,1.0,1.0)
	get_tree().reload_current_scene()

func _quit_button_pressed() -> void:
	_quit_label.modulate = Color(0.626, 0.626, 0.626, 1.0)

func _quit_button_released() -> void:
	_quit_label.modulate = Color(1.0,1.0,1.0,1.0)
	Transition.go_to(Globals.Scene.LAUNCH_SCREEN)

func _show_card() -> void:
	var winner:GameState.Player = GameState.get_winning_player()
	_avatar.texture   = GameState.get_player_avatar(winner)
	_color_rect.color = GameState.get_player_color(winner)
	_winner_name.text = GameState.get_player_name(winner)
	_count.text       = str( GameState.get_player_score(winner) )
	
	if winner == GameState.Player.DRAW:
		_draw_game.show()
	else:
		_avatar.show()
		_winner_name.show()
		_won_with.show()
		_count.show()
		_boxes.show()
	await get_tree().create_timer(3).timeout

	show()
	mouse_filter = Control.MOUSE_FILTER_STOP
