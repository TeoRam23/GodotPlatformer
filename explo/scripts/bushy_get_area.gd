extends Area2D

@onready var bushy_particle: CPUParticles2D = $BushyParticle
@onready var jeffrey_particle: CPUParticles2D = $JeffreyParticle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	swap_bushy()

func swap_bushy():
	if VariableManager.character_id != 2:
		Events.swap_character(2)
		#johnny_play_sprite.use_parent_material = true
		#jeffrey_particle.emitting = true
	elif VariableManager.character_id == 2:
		Events.swap_character(0)
		#johnny_play_sprite.use_parent_material = false
		#johnny_particle.emitting = true
	
	VariableManager.save_variables()
