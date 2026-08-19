@tool
class_name Box extends Node3D

@export var _player_1_material:StandardMaterial3D
@export var _player_2_material:StandardMaterial3D

@export var _has_pipe_north:bool = true
@export var _has_pipe_south:bool = true
@export var _has_pipe_east:bool  = true
@export var _has_pipe_west:bool  = true

@onready var _pipe_monitors:Node3D = $"Pipe Monitors"

@onready var _pipe_north: Pipe = $"Pipes/Pipe North"
@onready var _pipe_south: Pipe = $"Pipes/Pipe South"
@onready var _pipe_east: Pipe = $"Pipes/Pipe East"
@onready var _pipe_west: Pipe = $"Pipes/Pipe West"

@onready var _mesh:MeshInstance3D = $MeshInstance3D
@onready var _cpu_particles_3d:CPUParticles3D = $CPUParticles3D

var _claimed:bool = false
var _claimed_by:GameState.Player

func _ready() -> void:
	EventBus.game_finished.connect(_claim_and_explode)
	_mesh.hide()
	_cpu_particles_3d.hide()
	
	_set_pipes()

func _set_pipes() -> void:
	_pipe_north.enable()
	_pipe_south.enable()
	_pipe_east.enable()
	_pipe_west.enable()
	
	if not _has_pipe_north:
		_pipe_north.disable()
		
	if not _has_pipe_south:
		_pipe_south.disable()
	
	if not _has_pipe_east:
		_pipe_east.disable()
	
	if not _has_pipe_west:
		_pipe_west.disable()

func _set_mesh_material() -> void:
	match _claimed_by:
		GameState.Player.PLAYER_01: _mesh.material_override = _player_1_material
		GameState.Player.PLAYER_02: _mesh.material_override = _player_2_material
	
	_mesh.show()
	_cpu_particles_3d.show()

func _claim_and_explode() -> void:
	match GameState.get_winning_player():
		GameState.Player.PLAYER_01: 
			_mesh.material_override = _player_1_material
			_cpu_particles_3d.mesh.material = _player_1_material
		GameState.Player.PLAYER_02: 
			_mesh.material_override = _player_2_material
			_cpu_particles_3d.mesh.material = _player_2_material
	
	await get_tree().create_timer(.3 * get_index() + randf_range(-.1,.1)).timeout
	_mesh.hide()
	_cpu_particles_3d.emitting = true
	

func check_for_new_completion() -> bool:
	if _claimed:
		return false
		
	for pipe_monitor:PipeMonitor in _pipe_monitors.get_children():
		if not pipe_monitor.is_colliding():
			return false
	
	EventBus.score_increased.emit()
	_claimed    = true
	_claimed_by = GameState.get_active_player()
	
	for pipe_monitor:PipeMonitor in _pipe_monitors.get_children():
		pipe_monitor.set_claimed_by(_claimed_by)
		
	_set_mesh_material()
	
	return true
