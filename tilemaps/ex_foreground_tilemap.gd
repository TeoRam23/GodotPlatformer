extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Player forteller oss om å kjøre dette
func fade_away():
	print("hvordan starter denne???")
	#print("hmm: ", tile_set.get_physics_layer_collision_layer(0))
	tile_set.set_physics_layer_collision_layer(0, 0)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1)
	
