extends Area2D

#@onready var sprite_2d = $CollisionShape2D/Sprite2D
@onready var polygon_2d = $CollisionPolygon2D/Polygon2D

@export var area_direction = 0.0

func _ready():
#	if area_direction == 180 or area_direction == -180:
#		area_direction = 179.9999
	if area_direction > 180 or area_direction < -180:
		area_direction = (area_direction - 360) * sign(-area_direction)
		area_direction *= -1
	print(area_direction)
	var area_color = (area_direction + 90)/360
#	if area_color < 0:
#		area_color *= -1
#		area_color += 0.5
#	if area_color > 1:
#		area_color -= 1
		
	area_color *= 0.75
#	sprite_2d.modulate = Color.from_hsv(area_color, 1, 1, 0.75)
#	if sprite_2d:
#		sprite_2d.modulate = Color.from_hsv(area_color, 1, 1, 0.5)
#		print("box")
	if polygon_2d:
		polygon_2d.modulate = Color.from_hsv(area_color, 1, 1, 0.5)
		print("polygon")
	
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
