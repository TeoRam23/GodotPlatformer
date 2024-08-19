extends Button

@export var the_level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(the_level)
