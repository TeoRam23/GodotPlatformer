extends Area2D

@onready var sprite_2d = $Sprite2D

@export var area_direction = 0.0

func _ready():
	if area_direction == 90:
		sprite_2d.modulate = Color(0, 0.91, 0.212, 0.455)

#kanskje lage en til scene som er det samme men med polygon???