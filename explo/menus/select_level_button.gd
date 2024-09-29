extends Button

@export var the_level: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_pressed():
	if the_level:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		Input.warp_mouse(get_window().size * 0.5)
		get_tree().paused = false
		get_tree().change_scene_to_file(the_level)
