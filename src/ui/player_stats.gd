extends Control

@export var _player:GameState.Player

@onready var _player_score: Label = $"Score Container/Player Score"
@onready var _player_name:Label = $"HBoxContainer/Player Name"
@onready var _background:TextureRect = $Background
@onready var _player_label_animation:AnimationPlayer = $"Player Label Animation"
@onready var _avatar: TextureRect = $"HBoxContainer/Avatar Container/MarginContainer/Avatar"


func _ready() -> void:
	_set_background_color()
	_player_name.text = GameState.get_player_name(_player)
	_avatar.texture   = GameState.get_player_avatar(_player)
	
	EventBus.boxes_counted.connect(_update_score)
	EventBus.score_increased.connect(_update_score)
	EventBus.player_changed.connect(_toggle_active_indicator)
	
	_player_name.pivot_offset = _player_name.size / 2

func _set_background_color() -> void:
	_background.self_modulate = GameState.get_player_color(_player)

func _update_score() -> void:
	_player_score.text = str(GameState.get_player_score(_player)) + " / " + str(GameState.get_total_boxes() )

func _toggle_active_indicator() -> void:
	match GameState.get_active_player():
		_player: _player_label_animation.play("player_active")
		_: _player_label_animation.stop()
