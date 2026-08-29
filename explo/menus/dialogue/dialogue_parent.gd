extends CanvasLayer


@onready var dialogue_box: Panel = $DialogueBox
@onready var dialogue_label: Label = $DialogueBox/DialogueLabel
@onready var button_label: Label = $DialogueBox/ButtonLabel
@onready var audio_proceed: AudioStreamPlayer = $AudioProceed
@onready var audio_johnny: AudioStreamPlayer = $AudioJohnny
@onready var audio_bushy: AudioStreamPlayer = $AudioBushy
@onready var talk_timer: Timer = $TalkTimer

const THEME_JEFFREY = preload("uid://cfuoqyle7q3jc")
const THEME_JOHNNY = preload("uid://cci7qdm1rnxr4")

var dialogue_boxes = []
var dialogue_size = 0
var length_read = 0

var voice_length = 1

var running = false

var awaiting_answer = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	VariableManager.johnny_activated = false
	var children = get_children()
	for child in children:
		if child.is_in_group("dialogue_elements"):
			dialogue_boxes.append(child)
	
	dialogue_size = dialogue_boxes.size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start():
	print("starting...")
	dialogue_box.visible = true
	running = true
	
	if get_tree().paused: return
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.warp_mouse(get_window().size * 0.5)
	VariableManager.set_deferred("pausing_disabled", true)
	
	continue_box()
	# jeg må finne en måte å gå gjennom boxene i riktig rekkefølge, og etter hverandre generelt
	
func finish_dialogue(extra_info: bool):
	dialogue_box.visible = false
	running = false
	awaiting_answer = false
	length_read = 0
	
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	Input.warp_mouse(get_window().size * 0.5)
	VariableManager.set_deferred("pausing_disabled", false)
	
	Events.dialogue_finished(extra_info)

	print("finishing")



func continue_box():
	#audio_proceed.play()
	if length_read >= dialogue_size:
		finish_dialogue(false)
		return
	print("setting new text...")
	var dig = dialogue_boxes[length_read]
	
	if dig.yes_or_no:
		dialogue_label.visible = false
		button_label.visible = true
		button_label.text = dig.text
		
		awaiting_answer = true
	else:
		dialogue_label.visible = true
		button_label.visible = false
		dialogue_label.text = dig.text
	
	length_read += 1
	if dig.top:
		dialogue_box.position.y = 24.0
	else:
		dialogue_box.position.y = 232.0
	
	if dig.color == 0:
		dialogue_box.theme = THEME_JEFFREY
	elif dig.color == 1:
		dialogue_box.theme = THEME_JOHNNY
	
	# Jeg deler på 3 fordi det høres ut som en riktig mengde hå-er
	voice_length = int(dig.text.length()/3)
	talk(dig.color)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start") or event.is_action_pressed("musL"):
		if running and !awaiting_answer:
			continue_box()




func _on_button_yes_pressed() -> void:
	finish_dialogue(true)


func _on_button_no_pressed() -> void:
	finish_dialogue(false)



func talk(voice):
	if voice_length > 0:
		if voice == 1:
			audio_johnny.pitch_scale = randf_range(0.95, 1.05)
			audio_johnny.play()
		elif voice == 2:
			audio_bushy.pitch_scale = randf_range(0.95, 1.05)
			audio_bushy.play()
		else:
			return
		voice_length -= 1
		talk_timer.start()
		await talk_timer.timeout
		talk(voice)
	
