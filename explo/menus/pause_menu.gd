extends CanvasLayer

var title = "default"

@onready var number_label = $PauseControl/NumberLabel
@onready var level_title = $PauseControl/LevelTitle

# Called when the node enters the scene tree for the first time.
func _ready():
	number_label.text = "Level " + get_tree().current_scene.name
	Events.pls_share_title.connect(update_title)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_pressed():
	print("buttbutt")
	un_pause()

func _input(event):
	if event.is_action_pressed("back") and get_tree().paused:
		print("na")
		un_pause()

func un_pause():
	print("yup")
	get_tree().paused = false
	if get_parent().has_method("un_pause"):
		get_parent().un_pause()
		

func update_title(nytitle):
	#title = nytitle
	level_title.text = nytitle
