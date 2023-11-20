extends Area2D

@onready var sprite_2d = $Sprite2D

@export var area_direction = 0.0

func _ready():
	var area_color = (area_direction + 0)/360
	if area_color > 1:
		area_color -= 1
	sprite_2d.modulate = Color.from_hsv(area_color, 1, 1, 0.5)
#	if area_direction == 90:
#		sprite_2d.modulate = Color(0, 0.91, 0.212, 0.455)
#	if area_direction == -90:
#		sprite_2d.modulate = Color(0, 0.494, 0.953, 0.455)
#		sprite_2d.modulate = Color(0.5, 0, 1, 0.51)
#		sprite_2d.modulate = Color.from_hsv(0.5, 1, 1, 0.5)
#	if area_direction == 0:
#		sprite_2d.modulate = Color(1, 0, 0, 0.5)
#	if area_direction == 180:
#		sprite_2d.modulate = Color(0, 1, 1, 0.5)

#kanskje lage en til scene som er det samme men med polygon???
