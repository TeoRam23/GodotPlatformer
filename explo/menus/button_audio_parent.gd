extends Node2D

@onready var audio_hover: AudioStreamPlayer = $AudioHover
@onready var audio_pressed: AudioStreamPlayer = $AudioPressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	audio_hover.play()


func _on_pressed() -> void:
	if audio_pressed.is_inside_tree():
		
		audio_pressed.play()
