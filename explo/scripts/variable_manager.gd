extends Node

static var deaths = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(up_the_death)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func up_the_death():
	print("UPDATED")
	deaths += 1
