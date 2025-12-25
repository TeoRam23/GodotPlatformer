extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D):
	#Events.level_completed.emit()
	visible = false
	var current_level_id = get_tree().current_scene.name
	#print(current_level_id)
	#print(VariableManager.keys_collected)
	#print(VariableManager.level_keys)
	VariableManager.up_the_keys(current_level_id)
	
	Events.level_completed.emit()
	
