class_name CustomDrawingTool extends Control

@onready var _color_input:ColorPickerButton  = $VBoxContainer/HBoxContainer/ColorPickerButton
@onready var _drawing_surface:DrawingSurface = $"VBoxContainer/Control/Drawing Surface"

@onready var _paint_button:TouchScreenButton = $"VBoxContainer/HBoxContainer/Paint/Paint Button"
@onready var _erase_button:TouchScreenButton = $"VBoxContainer/HBoxContainer/Erase/Erase Button"
@onready var _clear_button:TouchScreenButton = $"VBoxContainer/HBoxContainer/Clear/Clear Button"

@onready var _paint_icon:TextureRect = $VBoxContainer/HBoxContainer/Paint
@onready var _erase_icon:TextureRect = $VBoxContainer/HBoxContainer/Erase
@onready var _clear_label:Label      = $VBoxContainer/HBoxContainer/Clear


var _drawable_texture:Texture2D
var _paint_color:Color = Color(0.0, 0.0, 0.317, 1.0)
var _erasing:bool = false

func _ready() -> void:
	_color_input.color_changed.connect(_change_color)
	_paint_button.released.connect(_paint_mode)
	_erase_button.released.connect(_erase_mode)
	_clear_button.released.connect(_clear)
	
	var color_picker:ColorPicker = _color_input.get_picker()
	color_picker.presets_visible     = false
	color_picker.can_add_swatches    = false
	color_picker.sliders_visible     = false
	color_picker.color_modes_visible = false
	
	_color_input.color = _paint_color
	
	_paint_mode()

func _change_color(color:Color) -> void:
	_paint_color = color
	_drawing_surface.set_color(_paint_color)

func _paint_mode() -> void:
	_erasing = false
	_erase_icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
	_paint_icon.modulate = Color(0.681, 0.414, 1.0, 1.0)
	_drawing_surface.set_paint_mode(_paint_color)

func _erase_mode() -> void:
	_erasing = true
	_paint_icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
	_erase_icon.modulate = Color(0.681, 0.414, 1.0, 1.0)
	_drawing_surface.set_erase_mode()

func _clear() -> void:
	_drawing_surface.clear_all()

func save_avatar(player:GameState.Player) -> void:
	GameState.set_player_avatar(player, _drawing_surface.get_texture())

func set_avatar( avatar_texture:Texture2D ) -> void:
	_drawing_surface.texture = avatar_texture
