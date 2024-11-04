extends Button

@export var the_level: String

@export var canceled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_part = the_level.get_file()
	level_part = level_part.substr(0, level_part.rfind("."))
	if VariableManager.find_level(level_part) or !canceled:
		print("ye: ", level_part)
		canceled = false
		
	else:
		print("nuu: ", level_part)
		cancel_me()
	


func _on_pressed():
	if the_level:
		Events.general_leaving()
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		Input.warp_mouse(get_window().size * 0.5)
		get_tree().paused = false
		get_tree().change_scene_to_file(the_level)


func cancel_me():
	#modulate = Color(0.5, 0.5, 0.5)
	disabled = true
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	#canceled = true
