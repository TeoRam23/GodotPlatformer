extends CanvasLayer


@onready var dialogue_box: Panel = $DialogueBox
@onready var dialogue_label: Label = $DialogueBox/DialogueLabel

var dialogue_boxes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_boxes = get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_dialogue():
	dialogue_box.visible = true
	# jeg må finne en måte å gå gjennom boxene i riktig rekkefølge, og etter hverandre generelt
	


func set_the_box(dig: Node):
	dialogue_label.text = dig.text


func finish_dialogue():
	pass

# bruk dette for å få musa hit og kan ikke sette på pause
#if get_tree().paused: return
	#get_tree().paused = true
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#Input.warp_mouse(get_window().size * 0.5)
	
# gå tilbake til normal
	#get_tree().paused = false
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	#Input.warp_mouse(get_window().size * 0.5)
