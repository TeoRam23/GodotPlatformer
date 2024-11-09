extends Button

@export var the_level: String
@export var title_override: String
@export var canceled = true

var level_vars: Dictionary

var label: Label
var time_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_part = the_level.get_file()
	level_part = level_part.substr(0, level_part.rfind("."))
	
	level_vars = VariableManager.find_level(level_part)
	if level_vars or !canceled:
		#print("ye: ", level_part)
		if title_override:
			level_vars.title = title_override
		canceled = false
		
	else:
		#print("nuu: ", level_part)
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


func _on_mouse_entered():
	if label is Label:
		if level_vars:
			label.text = level_vars.title
		else:
			label.text = "?????"
	
	if time_label is Label:
		if level_vars and level_vars.completed:
			time_label.text = format_time(level_vars.best_time)
		else:
			time_label.text = "??:??.???"


func format_time(time_elapsed):
	var show_time = snappedf(time_elapsed, 0.01666666666667)
	var minutes = int(floor(show_time * 0.01666666666667)) % 60
	var hours = floor(show_time / 3600)
	var seconds = int(show_time) % 60
	var millis = (show_time - floor(show_time)) * 1000
	var time_text = "%02d:%02d.%03d" % [minutes, seconds, millis]
	if hours:
		time_text = str(hours)+":" + time_text
	return str(time_text)
