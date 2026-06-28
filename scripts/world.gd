extends Node2D

@export var title = "World"
@export var next_level: PackedScene
@export var unlock_level_path: String
@export var show_mouse = false
@export var hub = false

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var black_screen = $CanvasLayer/BlackScreen
@onready var poof_level_animation = $PoofLevelAnimation
@onready var pause_menu = $PauseMenu
@onready var level_overlay = $LevelOverlay

var johnny_collected = false

var first_frame = true
var waiting = false

var locked_mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _ready():
	if show_mouse:
		locked_mouse_mode = Input.MOUSE_MODE_CONFINED
	if hub:
		if VariableManager.world_we_entered == "1":
			Events.tp_player(Vector2(0,11))
		elif VariableManager.world_we_entered == "2":
			Events.tp_player(Vector2(-144,-165))
		elif VariableManager.world_we_entered == "3":
			Events.tp_player(Vector2(144,-165))
		elif VariableManager.world_we_entered == "4":
			Events.tp_player(Vector2(0,-389))
		elif VariableManager.world_we_entered == "5":
			Events.tp_player(Vector2(0,619))
	#RenderingServer.set_default_clear_color(Color.BLACK)
	#RenderingServer.set_default_clear_color(Color(0.102, 0.102, 0.133))
	#RenderingServer.set_default_clear_color(Color(0.11, 0.11, 0.125))
	#RenderingServer.set_default_clear_color(Color.DARK_GREEN)
	Events.level_completed.connect(show_level_completed) #sjekker om noe har sendt "level_completed"
	
	Input.mouse_mode = locked_mouse_mode
	Input.warp_mouse(get_window().size * 0.5)
	VariableManager.pausing_disabled = false
	
	
	#level_overlay.update_title(title)
	Events.share_title(title)
	black_screen.reveal_level()
	
	Events.pls_johnny_collected.connect(lets_collect_johnny)
	
	# forteller manager at denne banen er tilgjengelig, men er ikke klart enda
	var this_level = {"id": get_tree().current_scene.name, "title": title, "completed": false, "best_time": -1.0, "johnny_collected": false}
	VariableManager.update_level_to(this_level)
	
	
	
#func _process(delta):
	#if first_frame:
		#reveal_level()
		#print("donet")
		#first_frame = false
	#if Input.is_action_pressed("musL"):
		#if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
func show_level_completed():
	level_completed.show() #gjør level_complete synlig
	get_tree().paused = true #setter alt i world på pause
	if not next_level is PackedScene:
		return
	get_tree().paused = false
	#get_tree().paused = true
	await get_tree().create_timer(1).timeout
	#waiting = true
	await poof_level_animation.hide_level()
	#await black_screen.transition_level()
	#await LevelTransition.fade_to_black()
	
	# i variablemanager gjør dette ingenting, men jeg vil ikke fjerne det enda
	VariableManager.current_title_time = 3
	
	if johnny_collected:
		VariableManager.up_the_johnnies()
	
	var level_time = level_overlay.time_label.time_elapsed
	
	var path := scene_file_path
	var my_current_name := path.get_file().get_basename()
	#print("new naming: ",my_current_name)
	#print("old naming: ",get_tree().current_scene.name)
	# id-en blir &"ekte_id" og det er helt greit at & er der, det går bra
	var this_level = {"id": my_current_name, "title": title, "completed": true, "best_time": level_time, "johnny_collected": johnny_collected}
	VariableManager.update_level_to(this_level)
	
	# dette er for å åpne opp en annen bane
	if unlock_level_path:
		var load_level = load(unlock_level_path)
		if load_level != null:
			var instanced_level = load_level.instantiate()
			var unlock_level = {"id": instanced_level.name, "title": instanced_level.title, "completed": false, "best_time": -1.0, "johnny_collected": false}
			VariableManager.update_level_to(unlock_level)
			instanced_level.free()
		load_level = null
		
	VariableManager.save_variables()
	
	get_tree().change_scene_to_packed(next_level)
	#LevelTransition.fade_from_black()

func un_pause():
	#print("ugh")
	Input.mouse_mode = locked_mouse_mode
	pause_menu.visible = false
	level_overlay.show_rest(false)
	VariableManager.set_deferred("pausing_disabled", false)
	if not Settings.touch_mode:
		Input.warp_mouse(get_window().size * 0.5)

func _input(event):
	if event.is_action_pressed("cancel") and not waiting and not VariableManager.pausing_disabled:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if not Settings.touch_mode:
			Input.warp_mouse(get_window().size * 0.5)
		
		pause_menu.visible = true
		pause_menu.i_am_paused = true
		level_overlay.show_rest(true)
		
		VariableManager.pausing_disabled = true
		print("denne kjører jo")
		get_tree().paused = true
	
	
	# Brukes for å endre til window eller fullscreen
	if Input.is_action_just_pressed("RMB"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	# Dette er en måte å få pila til å loope rundt skjermen. Jeg trenger det ikke mer, men det er her hvis jeg trenger det senere!
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE and 1==2:
		if event is InputEventMouseMotion:
			var screen_pos = get_screen_transform().origin * -1
			var mouse_pos = get_global_mouse_position()
			var windows_size = get_window().size
			#print(screen_pos)
			#print(mouse_pos)
			#print(mouse_pos - screen_pos)
			#print(windows_size)
			
			# Det å skjekke over og under hjelper ikke med at musa noen ganger ikke blir brakt til andre siden
			var new_mouse_pos = Vector2((mouse_pos.x - screen_pos.x) * (windows_size.x/640.0), (mouse_pos.y - screen_pos.y) * (windows_size.y/360.0))
			var old_mouse_pos = new_mouse_pos
			#print(new_mouse_pos)
			
			if new_mouse_pos.x <= 0:
				new_mouse_pos.x = windows_size.x - 2
			elif new_mouse_pos.x >= windows_size.x - 1:
				new_mouse_pos.x = 2
			if new_mouse_pos.y <= 0:
				new_mouse_pos.y = windows_size.y - 2
			elif new_mouse_pos.y >= windows_size.y - 1:
				new_mouse_pos.y = 2
			
			#if mouse_pos.x <= screen_pos.x:
				#new_mouse_pos.x = windows_size.x - 2
			#elif mouse_pos.x >= screen_pos.x + windows_size.x * 0.5 - 0.5:
				#new_mouse_pos.x = 1
			#if mouse_pos.y <= screen_pos.y:
				#new_mouse_pos.y = windows_size.y - 2
			#elif mouse_pos.y >= screen_pos.y + windows_size.y * 0.5 - 0.5:
				#new_mouse_pos.y = 1
			
			VariableManager.mouse_warped = Vector2(0, 0)
			if new_mouse_pos != old_mouse_pos and 2 == 1:
				Input.warp_mouse(new_mouse_pos)
				
				if new_mouse_pos.x != old_mouse_pos.x:
					VariableManager.mouse_warped.x = new_mouse_pos.x
				if new_mouse_pos.y != old_mouse_pos.y:
					VariableManager.mouse_warped.y = new_mouse_pos.y
				
				print("warped mate")
			########## Spørre chatgpt om ideer for å forbedre? ja pls jeg liker ikke dette :[
		

func lets_collect_johnny():
	johnny_collected = true

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Events.general_leaving()

#func reveal_level():
	#black_screen.visible = true
	#var tween = create_tween()
	#tween.tween_property(black_screen, "size", black_screen.size, 0.6) # litt delay
	#tween.tween_property(black_screen, "position", black_screen.position + Vector2(320, 0), 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	
	#print("...")
	#if black_screen.position.x < 1000:
		#black_screen.position.x += 1
		#call_deferred("reveal_level")
	
