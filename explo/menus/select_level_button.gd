extends Button

@export var the_level: String
@export var title_override: String
@export var canceled = true
@export var bonus = false

var level_vars: Dictionary

var label: Label
var time_label: Label

var tin_no_walking: TextureRect
var tin_constant_throwing: TextureRect
var tin_perfection: TextureRect
var tin_zero_gravity: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var level_part = the_level.get_file()
	level_part = level_part.substr(0, level_part.rfind("."))
	level_vars = VariableManager.find_level(level_part)
	
	
	if level_vars or !canceled:
		#print("ye: ", level_part)
		if !level_vars:
			level_vars.completed = false
		if title_override:
			level_vars.title = title_override
			
		canceled = false
		
		#VariableManager.delete_saved_level("Explo-1")
		#print(level_vars.id.split()[0])
		# sletter all data fra en verden, den i stringenet
		#if level_vars.id.split()[0] == "4" and 1==2:
			##VariableManager.update_level_to(this_level)
			#VariableManager.delete_saved_level(level_vars.id)
			#VariableManager.save_variables()
		
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
	
	if bonus:
		visible = false
	#canceled = true


func _on_mouse_entered():
	
	if label is Label:
		if level_vars:
			label.text = level_vars.title
		else:
			label.text = "?????"
	
	if time_label is Label:
		print(level_vars)
		if level_vars and level_vars.completed:
			time_label.text = format_time(level_vars.best_time)
		else:
			time_label.text = "??:??.???"
			
			
	if tin_no_walking is TextureRect:
		tin_no_walking.visible = false
	if tin_constant_throwing is TextureRect:
		tin_constant_throwing.visible = false
	if tin_perfection is TextureRect:
		tin_perfection.visible = false
	if tin_zero_gravity is TextureRect:
		tin_zero_gravity.visible = false

	if level_vars:
		print("vi kommer oss hit...")
		#print(level_vars)
		# burde sjekke om de eksisterer, men jeg gidder ikke, det går nok bra...
		if level_vars.no_walking and tin_no_walking is TextureRect:
			tin_no_walking.visible = true
		if level_vars.constant_throwing and tin_constant_throwing is TextureRect:
			tin_constant_throwing.visible = true
		if level_vars.perfection and tin_perfection is TextureRect:
			tin_perfection.visible = true
		if level_vars.zero_gravity and tin_zero_gravity is TextureRect:
			print("og hit...")
			tin_zero_gravity.visible = true


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
