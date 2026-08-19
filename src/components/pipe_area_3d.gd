class_name PipeArea3D extends Area3D

@export var _pipe:Pipe

func set_claimed_by(player:GameState.Player) -> void:
	_pipe.set_claimed_by(player)
