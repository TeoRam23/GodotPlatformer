extends CanvasLayer

@onready var cpu_particles_2d = $CPUParticles2D
@onready var cpu_particles_2d_2 = $CPUParticles2D2

@onready var black_screen = $BlackScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(reset_level)
	reveal_level()



func reveal_level():
	black_screen.visible = false
	cpu_particles_2d_2.emitting = true


func hide_level():
	cpu_particles_2d.emitting = true
	await get_tree().create_timer(0.25).timeout
	black_screen.visible = true


func reset_level():
	await get_tree().create_timer(0.5).timeout
	cpu_particles_2d.emitting = true
	await get_tree().create_timer(0.25).timeout
	black_screen.visible = true
	get_tree().paused = false
	get_tree().reload_current_scene()



#
#func _input(event):
	#if event.is_action_pressed("musL"):
		#cpu_particles_2d.emitting = true
		#await get_tree().create_timer(0.25).timeout
		#black_screen.visible = true
	#elif event.is_action_pressed("musR"):
		#black_screen.visible = false
		#cpu_particles_2d_2.emitting = true
		#await get_tree().create_timer(0.25).timeout

