extends Node2D

@export var extra_level: PackedScene

@onready var particles_2d = $Particles2D



# når player skal til extra level
func _on_soup_area_body_entered(body):
	if extra_level is PackedScene:
		Events.enter_extra()
		particles_2d.emitting = true
		#body.disable_player(false)
	#change_to_extra_level(body)
	#call_deferred("change_to_extra_level")

func change_to_extra_level():
		#VariableManager.save_variables()
		get_tree().change_scene_to_packed(extra_level)


func _on_particles_2d_finished():
	change_to_extra_level()
