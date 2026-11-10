extends Node

# får feilmelding ved bruk av variable.save, vet ikke hvorfor
#var save_path = "user://variable.save"
var save_path = "user://variable_1.save"
var save_path_2 = "user://variable_2.save"
var save_path_3 = "user://variable_3.save"
var save_path_default = "user://variable_default.save"

var save_file_used := 3

static var all_time = 0.0
static var deaths = 0
static var johnnies = 0
# jeg bruker ikke denne, men jeg er redd for å fjerne den fra save :(
static var keys_collected = 0
# array med id-en til alle banene hvor key er blitt collected
var level_keys = []

#static var johnny_mode = false
static var character_id = 0
# 0 er jeffrey, 1 er johnny, 2 er busk

static var johnny_activated = false

static var current_title_time = 3

#static var mouse_warped = Vector2.ZERO

# array med alle banene som er tilgjengelig og deres tid. -1 tid viser at banen ikke er klart enda
#var levels_completed = [{"id": &"1-1", "completed": false, "best_time": -1.0}]
static  var levels_completed = []

static var pausing_disabled = false

static var world_we_entered = "1"

static var saved_cursor_position = Vector2(75, 0)

static var opened_johnny_gate = false
static var opened_w5_gate = false
static var opened_speed_gate = false

static var end_time = 0.0
static var end_deaths = 0
static var all_levels_time = 0.0
static var all_levels_deaths = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var starting_savefile = save_file_used
	save_file_used = 4
	save_variables()
	save_file_used = starting_savefile
	load_variables()
	#print(levels_completed)
	
	
	Events.pls_player_died.connect(up_the_death)
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func up_the_death():
	deaths += 1

func up_the_johnnies():
	johnnies += 1


func find_level(level_id) -> Dictionary:
	# finner banen med id = level_id
	#print(levels_completed)
	for level in levels_completed:
		if level.id == level_id:
			return level
	return {}

func update_level_to(updated_level):
	#{"id": string, "title": string, "completed": bool, "best_time": time, "johnny_collected": bool}
	for level in levels_completed:
		
		if level.id == updated_level.id:
			if updated_level.completed:
				if updated_level.johnny_collected:
					level.johnny_collected = true
				if !level.completed:
					level.completed = updated_level.completed
					level.best_time = updated_level.best_time
				elif updated_level.best_time < level.best_time:
					level.best_time = updated_level.best_time
				
				#set challenges
				if Settings.no_walking and not Settings.constant_throwing and not Settings.zero_gravity:
					level.no_walking = true
				if Settings.constant_throwing and not Settings.no_walking and not Settings.zero_gravity:
					level.constant_throwing = true
				if Settings.no_walking and Settings.constant_throwing and not Settings.zero_gravity:
					level.perfection = true
				if Settings.zero_gravity:
					level.zero_gravity = true
				
			return


	updated_level["no_walking"] = false
	updated_level["constant_throwing"] = false
	updated_level["perfection"] = false
	updated_level["zero_gravity"] = false
	
	levels_completed.append(updated_level)

func delete_saved_level(level_victim_id):
	#var test_array = [{id = "shoop", thingy = 35}, {id = "sheep", thingy = 12}]
	for level in levels_completed:
		if level.id == level_victim_id:
			#print(levels_completed)
			levels_completed.erase(level)
			print("Level deleted: ", level)
			#print("################################ ", levels_completed, " #########################")
			


func up_the_keys(level_id: String):
	var key_taken = false
	for level in level_keys:
		if level == level_id:
			print("denne er her allerede")
			key_taken = true
	if key_taken:
		print("key er tatt, gjør ingenting")
	else:
		print("dette er en ny key, la oss lagre den!")
		#keys_collected += 1
		level_keys.append(level_id)


func get_savefile_info(picked_file: int) -> Array:
	var file
	if picked_file == 1:
		if not FileAccess.file_exists(save_path):
			print('Welp, no save when getting ¯\\_ツ)_/¯')
			return [0, 0]
		else:
			file = FileAccess.open(save_path, FileAccess.READ)
	elif picked_file == 2:
		if not FileAccess.file_exists(save_path_2):
			print('Welp, no save when getting ¯\\_ツ)_/¯')
			return [0, 0]
		else:
			file = FileAccess.open(save_path_2, FileAccess.READ)
	elif picked_file == 3:
		if not FileAccess.file_exists(save_path_3):
			print('Welp, no save when getting ¯\\_ツ)_/¯')
			return [0, 0]
		else:
			file = FileAccess.open(save_path_3, FileAccess.READ)
	else:
		return [0, 0]
	
	var stored_all_time = all_time
	all_time = file.get_var()
	var gotten_all_time = all_time
	all_time = stored_all_time
	
	var stored_deaths = deaths
	deaths = file.get_var()
	var gotten_deaths = deaths
	deaths = stored_deaths
	
	return [gotten_all_time, gotten_deaths]
	

func delete_savefile(picked_file):
	#if picked_file == 1 and FileAccess.file_exists(save_path):
	save_file_used = 4
	load_variables()
	save_file_used = picked_file
	save_variables()
		#DirAccess.remove_absolute(save_path)
	#elif picked_file == 2 and FileAccess.file_exists(save_path_2):
		#DirAccess.remove_absolute(save_path_2)
	#elif picked_file == 3 and FileAccess.file_exists(save_path_3):
		#DirAccess.remove_absolute(save_path_3)


# Saver variables til variable.save
func save_variables():
	var file
	if save_file_used == 1:
		file = FileAccess.open(save_path, FileAccess.WRITE)
	if save_file_used == 2:
		file = FileAccess.open(save_path_2, FileAccess.WRITE)
	elif save_file_used == 3:
		file = FileAccess.open(save_path_3, FileAccess.WRITE)
	elif save_file_used == 4:
		file = FileAccess.open(save_path_default, FileAccess.WRITE)
	file.store_var(all_time)
	file.store_var(deaths)
	file.store_var(johnnies)
	file.store_var(keys_collected)
	file.store_var(level_keys)
	#file.store_var(johnny_mode)
	file.store_var(character_id)
	file.store_var(johnny_activated)
	file.store_var(levels_completed)
	file.store_var(opened_johnny_gate)
	file.store_var(opened_w5_gate)
	file.store_var(opened_speed_gate)
	file.store_var(end_time)
	file.store_var(end_deaths)
	file.store_var(all_levels_time)
	file.store_var(all_levels_deaths)
	file.close()
	#print(levels_completed)

# Loader variables fra variable.save
func load_variables():
	var file
	if save_file_used == 2:
		if not FileAccess.file_exists(save_path_2):
			print('Welp, no save here ¯\\_ツ)_/¯')
			return
		else:
			file = FileAccess.open(save_path_2, FileAccess.READ)
	elif save_file_used == 3:
		if not FileAccess.file_exists(save_path_3):
			print('Welp, no save here ¯\\_ツ)_/¯')
			return
		else:
			file = FileAccess.open(save_path_3, FileAccess.READ)
	elif save_file_used == 1:
		if not FileAccess.file_exists(save_path):
			print('Welp, no save here ¯\\_ツ)_/¯')
			return
		else:
			file = FileAccess.open(save_path, FileAccess.READ)
	elif save_file_used == 4:
		if not FileAccess.file_exists(save_path_default):
			print('Welp, no save here ¯\\_ツ)_/¯')
			return
		else:
			file = FileAccess.open(save_path_default, FileAccess.READ)
	else:
		return
	
	all_time = file.get_var()
	deaths = file.get_var()
	johnnies = file.get_var()
	keys_collected = file.get_var()
	level_keys = file.get_var()
	#johnny_mode = file.get_var()
	character_id = file.get_var()
	johnny_activated = file.get_var()
	levels_completed = file.get_var()
	opened_johnny_gate = file.get_var()
	opened_w5_gate = file.get_var()
	opened_speed_gate = file.get_var()
	end_time = file.get_var()
	end_deaths = file.get_var()
	all_levels_time = file.get_var()
	all_levels_deaths = file.get_var()
	
	#print(levels_completed)
	file.close()
