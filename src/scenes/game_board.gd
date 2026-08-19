extends Node3D

const BOARD_WIDTH:int  = 11
const BOARD_HEIGHT:int = 12

@onready var _dots:MultiMeshInstance3D  = $Dots

func _ready() -> void:
	GameState.start_new_game()
	_place_dots()
	_set_materials()
	EventBus.transition_completed.emit()

func _set_materials() -> void:
	var _player_1_material:StandardMaterial3D = preload("res://src/materials/player_01_material.tres")
	var _player_2_material:StandardMaterial3D = preload("res://src/materials/player_02_material.tres")
	
	_player_1_material.albedo_color = GameState.get_player_color(GameState.Player.PLAYER_01)
	_player_2_material.albedo_color = GameState.get_player_color(GameState.Player.PLAYER_02)

func _place_dots() -> void:
	var multimesh:MultiMesh = _dots.multimesh
	for i:int in range(multimesh.instance_count):
		var x_pos = i % BOARD_WIDTH
		var z_pos = floori( i / BOARD_HEIGHT)
		
		# Create position transform
		var t = Transform3D()
		t.origin = Vector3(x_pos, 0, z_pos) # Slight wave offset
		
		multimesh.set_instance_transform(i, t)
