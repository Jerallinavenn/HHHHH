extends Area2D

var is_pressed: bool = false

@export var normal_texture: Texture2D
@export var pressed_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

signal button_pressed(button_name: String)

func _ready():
	if normal_texture:
		sprite.texture = normal_texture

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		is_pressed = not is_pressed
		emit_signal("button_pressed", name)
		
		# Не меняем текстуру здесь, это делает Maingame.gd
