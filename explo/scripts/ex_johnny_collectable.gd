extends Area2D

@onready var sploot_particle = $SplootParticle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	VariableManager.up_the_johnnies()
	
	remove_child(sploot_particle)
	get_parent().add_child(sploot_particle)
	sploot_particle.emitting = true
	sploot_particle.global_position = global_position
	
	queue_free()
