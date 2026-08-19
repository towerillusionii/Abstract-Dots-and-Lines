class_name PipeMonitor extends Area3D

var _collisions:Array[PipeArea3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = true
	monitorable = false
	
	set_collision_layer(0)
	set_collision_mask(0)
	set_collision_mask_value(2, true)
	
	area_entered.connect(_save_pipe_collision)
	area_exited.connect(_erase_pipe_collision)

func _save_pipe_collision(pipe:PipeArea3D) -> void:
	if pipe not in _collisions:
		_collisions.push_back(pipe)

func _erase_pipe_collision(pipe:PipeArea3D) -> void:
	if pipe in _collisions:
		_collisions.erase(pipe)

func set_claimed_by(player:GameState.Player) -> void:
	for pipe in _collisions:
		pipe.set_claimed_by(player)

func is_colliding() -> bool:
	return not _collisions.is_empty()
