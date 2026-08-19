extends Node2D

@export var _packed_launch_screen:PackedScene
@export var _packed_player_config:PackedScene
@export var _packed_game_board:PackedScene

@onready var _transition_timer:Timer = $"Transition Timer"
@onready var _animation_player:AnimationPlayer = $AnimationPlayer
@warning_ignore("unused_private_class_variable")
@onready var _falling_dots_and_lines:FallingDotsAndLines = $"SubViewport/Falling Dots and Lines"


var _previous_scene:Globals.Scene = Globals.Scene.NONE
var _current_scene:Globals.Scene = Globals.Scene.LAUNCH_SCREEN
var _ready_to_fade_out:bool = false

func _ready() -> void:
	EventBus.transition_completed.connect(_transition_completed)
	_transition_timer.timeout.connect(_on_transition_timer_timeout)

func go_to(scene:Globals.Scene) -> void:
	if scene == _current_scene:
		return
		
	match scene:
		Globals.Scene.LAUNCH_SCREEN: _transition(_packed_launch_screen, scene)
		Globals.Scene.PLAYER_CONFIG: _transition(_packed_player_config, scene)
		Globals.Scene.GAME_BOARD:    _transition(_packed_game_board,    scene)

func _transition(which:PackedScene, scene:Globals.Scene) -> void:
	_previous_scene = _current_scene
	_current_scene  = scene
	_animation_player.play("fade_in")
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_packed(which)
	_transition_timer.start()

func _transition_completed() -> void:
	_ready_to_fade_out = true
	
func _on_transition_timer_timeout() -> void:
	if _ready_to_fade_out:
		_ready_to_fade_out = false
		_animation_player.play("fade_out")
		_transition_timer.stop()
