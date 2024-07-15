extends Node2D

@export var next_level: PackedScene

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var black_screen = $CanvasLayer/BlackScreen

var first_frame = true

func _ready():
	RenderingServer.set_default_clear_color(Color.DARK_GREEN)
	Events.level_completed.connect(show_level_completed) #sjekker om noe har sendt "level_completed"
	
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	reveal_level()
	
func _process(delta):
	#if first_frame:
		#reveal_level()
		#print("donet")
		#first_frame = false
	if Input.is_action_pressed("musL"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
func show_level_completed():
	level_completed.show() #gjør level_complete synlig
	get_tree().paused = true #setter alt i world på pause
	if not next_level is PackedScene:
		return
	get_tree().paused = true
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	LevelTransition.fade_from_black()



func _input(event):
	if event.is_action_pressed("cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func reveal_level():
	black_screen.visible = true
	var tween = create_tween()
	tween.tween_property(black_screen, "size", black_screen.size, 0.6) # litt delay
	tween.tween_property(black_screen, "position", black_screen.position + Vector2(320, 0), 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#print("...")
	#if black_screen.position.x < 1000:
		#black_screen.position.x += 1
		#call_deferred("reveal_level")
	
