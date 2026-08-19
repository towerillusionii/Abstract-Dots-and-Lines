class_name LineSelector extends Area3D

func _unhandled_input(event: InputEvent) -> void:
	var camera:Camera3D = get_viewport().get_camera_3d()
	
	if event is InputEventScreenTouch and event.pressed:
		var ray_origin:Vector3 = camera.project_position(event.position, camera.position.y)
	
		global_position.x = ray_origin.x
		global_position.z = ray_origin.z
