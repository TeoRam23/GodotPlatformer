extends Area2D

var root_name
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	root_name = get_tree().current_scene.name
	
	for key in VariableManager.level_keys:
		if key == root_name:
			disable_me()
	
	#VariableManager.level_keys = []
	#VariableManager.keys_collected = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D):
	#Events.level_completed.emit()
	visible = false
	#print(current_level_id)
	#print(VariableManager.keys_collected)
	#print(VariableManager.level_keys)
	VariableManager.up_the_keys(root_name)
	
	Events.level_completed.emit()
	
func disable_me():
	modulate = Color(0.5, 0.5, 0.5)
	animated_sprite_2d.speed_scale = 0.75
	
	cpu_particles_2d.emitting = false
