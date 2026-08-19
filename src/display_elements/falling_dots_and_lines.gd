class_name FallingDotsAndLines extends Node3D

@onready var _purple_lines:CPUParticles3D = $"Purple Lines"
@onready var _purple_dots:CPUParticles3D  = $"Purple Dots"
@onready var _yellow_lines:CPUParticles3D = $"Yellow Lines"
@onready var _yellow_dots:CPUParticles3D  = $"Yellow Dots"

func start_falling() -> void:
	_purple_lines.emitting = true
	_purple_dots.emitting  = true
	_yellow_lines.emitting = true
	_yellow_dots.emitting  = true
