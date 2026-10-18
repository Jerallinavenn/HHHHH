extends Sprite2D

# Переменные
@export var light_on: bool = true

func _process(_delta):
	if get_parent().power_out:
		texture = preload("res://office_dark.png")
	else:
		texture = preload("res://office_light.png")
