class_name DrawingSurface extends TextureRect

var drawing = false
var my_color = Color.RED
var my_size = 16.0

func _ready():
	texture = DrawableTexture2D.new()
	texture.setup(460, 460, DrawableTexture2D.DRAWABLE_FORMAT_RGBAH, Color(1.0, 1.0, 1.0, 1.0), false)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		drawing = not drawing
	if event is InputEventMouseMotion and drawing:
		var rect = Rect2(event.position.x - my_size / 2, event.position.y - my_size / 2, my_size, my_size)
		texture.blit_rect(rect, preload("res://assets/images/ui/blit_circle.png"), my_color, 0)

func set_color(color:Color):
	my_color = color

func set_paint_mode(color:Color):
	my_color = color

func set_erase_mode() -> void:
	my_color = Color(1.0, 1.0, 1.0, 1.0)

func clear_all() -> void:
	var rect = Rect2(-230, -230, 920, 920)
	texture.blit_rect(rect, preload("res://assets/images/ui/blit_circle.png"), Color(1,1,1,1.0), 0)
