extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(i_invis)
	pass # Replace with function body.


		

func un_emit():
	var children = get_children()
	for child in children:
		child.emitting = false

func _on_throw_dust_finished():
	queue_free()

func i_invis():
	visible = false
