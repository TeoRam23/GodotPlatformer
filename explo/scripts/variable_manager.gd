extends Node

static var all_time = 0.0
static var deaths = 0
static var johnnies = 0

static var current_title_time = 3

signal johnny_collect

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(up_the_death)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func up_the_death():
	print("UPDATED")
	deaths += 1

func up_the_johnnies():
	johnnies += 1
	Events.johnny_collected()
