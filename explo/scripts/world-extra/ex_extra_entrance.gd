extends Node2D

@export var extra_level: PackedScene

@onready var particles_2d = $Particles2D
@onready var new_particles_2d: CPUParticles2D = $NewParticles2D
@onready var timer: Timer = $Timer
@onready var transition_timer: Timer = $TransitionTimer
@onready var hide_extras: CPUParticles2D = $CanvasLayer/HideExtras

@onready var shhppff_timer: Timer = $SHHPPFFTimer
@onready var shhppff_rect: ColorRect = $SHHPPFFRect
@onready var shhppff_particle: CPUParticles2D = $SHHPPFFParticle

var has_requested_hide_anim = false

func _ready() -> void:
	Events.pls_finished_hide_level_particles.connect(change_to_extra_level)

# når player skal til extra level
func _on_soup_area_body_entered(body):
	if extra_level is PackedScene:
		Events.enter_extra()
		particles_2d.emitting = true
		timer.start()
		transition_timer.start()
		shhppff_timer.start()
		#body.disable_player(false)
	#change_to_extra_level(body)
	#call_deferred("change_to_extra_level")

func change_to_extra_level():
	if has_requested_hide_anim:
		#VariableManager.save_variables()
		get_tree().change_scene_to_packed(extra_level)


#func _on_particles_2d_finished():
	#Events.play_hide_level_particles()
	#change_to_extra_level()


func _on_timer_timeout() -> void:
	has_requested_hide_anim = true
	Events.play_hide_level_particles()


func _on_transition_timer_timeout() -> void:
	
	hide_extras.emitting = true


func _on_shhppff_timer_timeout() -> void:
	shhppff_rect.visible = true
	shhppff_particle.emitting = true
	new_particles_2d.emitting = true
