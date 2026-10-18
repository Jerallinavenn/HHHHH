extends Area2D

# Переменные
@export var active: bool = false

func _on_PlayerCassette_area_entered(area):
	if area.name == "Mouse":
		active = not active
		$Sprite.texture = preload("res://cassette_player_highlighted.png") if active else preload("res://cassette_player_light.png")
