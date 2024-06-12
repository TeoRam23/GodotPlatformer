extends CollisionPolygon2D
var sides
var polygonIwant

# Called when the node enters the scene tree for the first time.
func _ready():
	sides = get_parent().sides
	generate_circle_polygon(32, sides)
	polygon = polygonIwant
	var child = get_children()[0]
	child.polygon = polygonIwant


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_circle_polygon(radius: float, num_sides: int) -> PackedVector2Array:
	var angle_delta: float = (PI * 2) / num_sides
	var vector: Vector2 = Vector2(radius, 0)
	var polygon: PackedVector2Array

	for _i in num_sides:
		polygon.append(vector)
		vector = vector.rotated(angle_delta)
#		print("goog job Ferb!")ffff
	polygonIwant = polygon
	return polygon
