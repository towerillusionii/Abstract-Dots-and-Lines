@tool
class_name Pipe extends Node3D

enum Orientation {
	VERTICAL,
	HORIZONTAL
}

@export var _orientation:Orientation
@export var _player_1_material:StandardMaterial3D
@export var _player_2_material:StandardMaterial3D

@onready var _touch_monitor:Area3D = $"Touch Monitor"
@onready var _pipe_area:Area3D     = $"Pipe Area"
@onready var _mesh:MeshInstance3D  = $MeshInstance3D
@onready var _cpu_particles_3d:CPUParticles3D = $CPUParticles3D
@onready var _audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer

var _enabled:bool = true
var _can_be_selected:bool = true

var _activated:bool = false
var _activated_by:GameState.Player
var _claimed:bool = false
var _claimed_by:GameState.Player

func _ready() -> void:
	_set_orientation()

	if not Engine.is_editor_hint():
		_touch_monitor.area_entered.connect(_select)
		EventBus.pipe_selected.connect(_pause_interaction)
		EventBus.round_started.connect(_resume_interaction)
		_mesh.hide()

func _set_orientation() -> void:
	if _orientation == Orientation.HORIZONTAL:
		rotation.y = deg_to_rad(0)
	if _orientation == Orientation.VERTICAL:
		rotation.y = deg_to_rad(90)

func disable() -> void:
	hide()
	_enabled = false

func enable() -> void:
	show()
	_enabled = true

func _pause_interaction() -> void:
	_can_be_selected = false

func _resume_interaction() -> void:
	_can_be_selected = true

func _set_mesh_material(player:GameState.Player) -> void:
	match player:
		GameState.Player.PLAYER_01: 
			_mesh.material_override = _player_1_material
			_cpu_particles_3d.mesh.material = _player_1_material
		GameState.Player.PLAYER_02: 
			_mesh.material_override = _player_2_material
			_cpu_particles_3d.mesh.material = _player_2_material
	
	_cpu_particles_3d.emitting = true
	_mesh.show()
	
func _select(_area:Area3D) -> void:
	if not _enabled:
		return
		
	if not _activated and _can_be_selected:
		_audio_stream_player.play()
		_activated = true
		_pipe_area.set_collision_layer_value(2, true)
		_activated_by = GameState.get_active_player()
		_set_mesh_material(_activated_by)

		EventBus.pipe_selected.emit()

func set_claimed_by(player:GameState.Player) -> void:
	if not _enabled:
		return
		
	if not _claimed:
		_claimed = true
		_claimed_by = player
		_set_mesh_material(_claimed_by)
