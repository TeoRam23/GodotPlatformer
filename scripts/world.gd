extends Node2D

@export var next_level: PackedScene

@onready var level_completed = $CanvasLayer/LevelCompleted

func _ready():
	RenderingServer.set_default_clear_color(Color.DARK_GREEN)
	Events.level_completed.connect(show_level_completed) #sjekker om kyllingen har sendt "level_completed"
	
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
func _process(delta):
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
