extends Node2D

@export var next_level: PackedScene

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var black_screen = $CanvasLayer/BlackScreen
@onready var poof_level_animation = $PoofLevelAnimation
@onready var pause_menu = $PauseMenu
@onready var level_overlay = $LevelOverlay

var first_frame = true
var waiting = false

func _ready():
	#RenderingServer.set_default_clear_color(Color.BLACK)
	#RenderingServer.set_default_clear_color(Color(0.102, 0.102, 0.133))
	RenderingServer.set_default_clear_color(Color(0.11, 0.11, 0.125))
	#RenderingServer.set_default_clear_color(Color.DARK_GREEN)
	Events.level_completed.connect(show_level_completed) #sjekker om noe har sendt "level_completed"
	
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	black_screen.reveal_level()
	
	
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
	waiting = true
	await poof_level_animation.hide_level()
	#await black_screen.transition_level()
	#await LevelTransition.fade_to_black()
	get_tree().change_scene_to_packed(next_level)
	#LevelTransition.fade_from_black()

func un_pause():
	print("ugh")
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	pause_menu.visible = false
	level_overlay.show_rest(false)

func _input(event):
	if event.is_action_pressed("cancel") and not waiting:
		
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Input.warp_mouse(get_window().size * 0.5)
		
		pause_menu.visible = true
		level_overlay.show_rest(true)
		
		get_tree().paused = true
		
	if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		if event is InputEventMouseMotion:
			var screen_pos = get_screen_transform().origin * -1
			var mouse_pos = get_global_mouse_position()
			var windows_size = get_window().size
			#print(screen_pos)
			#print(mouse_pos)
			#print(mouse_pos - screen_pos)
			#print(windows_size)
			
			# Det å skjekke over og under hjelper ikke med at musa noen ganger ikke blir brakt til andre siden
			var new_mouse_pos = Vector2(mouse_pos.x - screen_pos.x, mouse_pos.y - screen_pos.y) * 2
			
			#print(new_mouse_pos)
			
			if new_mouse_pos.x <= 0:
				new_mouse_pos.x = windows_size.x - 2
			elif new_mouse_pos.x >= windows_size.x - 1:
				new_mouse_pos.x = 1
			if new_mouse_pos.y <= 0:
				new_mouse_pos.y = windows_size.y - 2
			elif new_mouse_pos.y >= windows_size.y - 1:
				new_mouse_pos.y = 1
			
			#if mouse_pos.x <= screen_pos.x:
				#new_mouse_pos.x = windows_size.x - 2
			#elif mouse_pos.x >= screen_pos.x + windows_size.x * 0.5 - 0.5:
				#new_mouse_pos.x = 1
			#if mouse_pos.y <= screen_pos.y:
				#new_mouse_pos.y = windows_size.y - 2
			#elif mouse_pos.y >= screen_pos.y + windows_size.y * 0.5 - 0.5:
				#new_mouse_pos.y = 1
			
			if new_mouse_pos != Vector2.ZERO:
				Input.warp_mouse(new_mouse_pos)
			########## Spørre chatgpt om ideer for å forbedre? ja pls jeg liker ikke dette :[
		


#func reveal_level():
	#black_screen.visible = true
	#var tween = create_tween()
	#tween.tween_property(black_screen, "size", black_screen.size, 0.6) # litt delay
	#tween.tween_property(black_screen, "position", black_screen.position + Vector2(320, 0), 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	
	#print("...")
	#if black_screen.position.x < 1000:
		#black_screen.position.x += 1
		#call_deferred("reveal_level")
	
