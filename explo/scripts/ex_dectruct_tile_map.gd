extends TileMap

var gonna_free = false
# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if gonna_free:
		free()
	#pass


func explode():
	call_deferred("free")
	print("sploded!")
	gonna_free = true
