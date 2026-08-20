extends Node

enum Player {
	PLAYER_01,
	PLAYER_02,
	DRAW
}

var _active_player:Player = Player.PLAYER_01
var _player_1_score:int = 0
var _player_2_score:int = 0
var _player_1_name:String = "Player 01"
var _player_2_name:String = "Player 02"
var _player_1_avatar:Texture2D = DrawableTexture2D.new()
var _player_2_avatar:Texture2D = DrawableTexture2D.new()
var _player_1_color:Color = Color(0.551, 0.314, 1.0, 1.0)
var _player_2_color:Color = Color(1.0, 1.0, 0.0, 1.0)
var _box_count:int = 0

func _ready() -> void:
	EventBus.score_increased.connect(_increase_score)
	EventBus.turn_finished.connect(_change_active_player)
	
	_player_1_avatar.setup(460, 460, DrawableTexture2D.DRAWABLE_FORMAT_RGBA8, Color(1.0, 1.0, 1.0, 1.0), false)
	_player_2_avatar.setup(460, 460, DrawableTexture2D.DRAWABLE_FORMAT_RGBA8, Color(1.0, 1.0, 1.0, 1.0), false)

func _increase_score() -> void:
	if _active_player == Player.PLAYER_01:
		_player_1_score += 1
		
	if _active_player == Player.PLAYER_02:
		_player_2_score +=1
	
		
	if _player_1_score + _player_2_score >= _box_count:
		EventBus.game_finished.emit()
	else:
		EventBus.round_started.emit()

func _change_active_player() -> void:
	match _active_player:
		Player.PLAYER_01: _active_player = Player.PLAYER_02
		Player.PLAYER_02: _active_player = Player.PLAYER_01
	EventBus.player_changed.emit()
	EventBus.round_started.emit()

func get_active_player() -> Player:
	return _active_player

func increase_box_count() -> void:
	_box_count += 1

func get_total_boxes() -> int:
	return _box_count

func get_player_score(player:GameState.Player) -> int:
	match player:
		Player.PLAYER_01: return _player_1_score
		Player.PLAYER_02: return _player_2_score
	
	return -1

func get_player_name(player:GameState.Player) -> String:
	match player:
		Player.PLAYER_01: return _player_1_name
		Player.PLAYER_02: return _player_2_name
	
	return "I AM ERROR"

func set_player_name(player:GameState.Player, player_name:String) -> void:
	match player:
		Player.PLAYER_01: _player_1_name = player_name
		Player.PLAYER_02: _player_2_name = player_name

func get_active_player_name() -> String:
	return get_player_name(_active_player)

func get_player_color(player:GameState.Player) -> Color:
	match player:
		Player.PLAYER_01: return _player_1_color
		Player.PLAYER_02: return _player_2_color
	
	return Color(1.0, 0.282, 1.0, 1.0)

func get_active_player_color() -> Color:
	return get_player_color(_active_player)

func set_player_color(player:GameState.Player, color:Color) -> void:
	match player:
		Player.PLAYER_01: _player_1_color = color
		Player.PLAYER_02: _player_2_color = color

func get_player_avatar(player:GameState.Player) -> Texture:
	match player:
		Player.PLAYER_01: return _player_1_avatar
		Player.PLAYER_02: return _player_2_avatar
	
	return null

func set_player_avatar(player:GameState.Player, avatar:Texture2D) -> void:
	match player:
		Player.PLAYER_01: _player_1_avatar = avatar
		Player.PLAYER_02: _player_2_avatar = avatar

func get_winning_player() -> GameState.Player:
	if _player_1_score > _player_2_score:
		return GameState.Player.PLAYER_01
	elif _player_2_score > _player_1_score:
		return GameState.Player.PLAYER_02
	else:
		return GameState.Player.DRAW

func start_new_game() -> void:
	_active_player = Player.PLAYER_01
	_player_1_score = 0
	_player_2_score = 0
