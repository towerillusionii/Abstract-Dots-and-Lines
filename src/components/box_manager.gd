class_name BoxManager extends Node

var _boxes:Array[Box]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for row:Node3D in get_children():
		for box:Box in row.get_children():
			_boxes.push_back(box)
			GameState.increase_box_count()
	
	EventBus.boxes_counted.emit()
	EventBus.pipe_selected.connect(_find_new_box_completion)

func _find_new_box_completion() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	var new_box:bool = false
	
	for box:Box in _boxes:
		if box.check_for_new_completion():
			new_box = true
			
	if not new_box:
		EventBus.turn_finished.emit()
	else:
		EventBus.bonus_turn_earned.emit()
		
