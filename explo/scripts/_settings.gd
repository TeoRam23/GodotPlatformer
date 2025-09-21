extends Node

#jeg tror jeg lagrer til settings så jeg kanskje kan ha flere filer for savefiles men ha samme settings, for nå
var save_path = "user://settings.save"


# HUSK å legge nye settinger til i SAVE og LOAD func-ene!
var show_game_timer = true
var show_level_timer = true
var show_death_counter = true

var locked_cursor = true

var touch_mode = false

var no_walking = false
var constant_throwing = false
var zero_gravity = false



# Called when the node enters the scene tree for the first time.
func _ready():
	# dette burde ikke være her når vi er ferdig! AAAAAAAAAAAA
	#save_settings()
	
	load_settings()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_settings():
	# dette er hvordan jeg lagrer til settings
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_var(show_game_timer)
	file.store_var(show_level_timer)
	file.store_var(show_death_counter)
	
	file.store_var(locked_cursor)
	
	file.store_var(touch_mode)
	
	file.store_var(no_walking)
	file.store_var(constant_throwing)
	file.store_var(zero_gravity)
		
	print("###########HOOOOOOOOOOOOOOOO saved this setting i think! #####################")
	
func load_settings():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		
		show_game_timer = file.get_var()
		show_level_timer = file.get_var()
		show_death_counter = file.get_var()
		
		locked_cursor = file.get_var()
		
		touch_mode = file.get_var()
		
		no_walking = file.get_var()
		constant_throwing = file.get_var()
		zero_gravity = file.get_var()
		
		file.close()
	else:
		print("no savefile for settings, whoops :o")
	
	#if FileAccess.file_exists(save_path):
		#var file = FileAccess.open(save_path, FileAccess.READ)
		#all_time = file.get_var()
		#deaths = file.get_var()
		#johnnies = file.get_var()
		#johnny_mode = file.get_var()
		#levels_completed = file.get_var()
		##print(levels_completed)
		#file.close()
	#else:
		#print('Welp, no save here ¯\\_ツ)_/¯')
		#return
