extends CanvasLayer

@onready var hide_particle = $HideParticle
@onready var reveal_particle = $RevealParticle

@onready var black_screen = $BlackScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_player_died.connect(reset_level)
	reveal_level()


func reveal_level():
	visible = true
	black_screen.visible = false
	reveal_particle.emitting = true


func hide_level():
	hide_particle.emitting = true
	await do_timer(0.25)
	
	black_screen.visible = true


func reset_level():
	await do_timer(0.5)
	hide_particle.emitting = true
	await do_timer(0.25)
	black_screen.visible = true
	get_tree().paused = false
	Events.resetting_level()
	print("HOOOOOOOOOOOOOOOOOOOOOO")
	get_tree().reload_current_scene()

func do_timer(seconds):
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(timer)
	timer.start()
	
	await timer.timeout
	timer.queue_free()
	#var new_timer = get_tree().create_timer(seconds)
	#print(new_timer)
	#new_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	#await new_timer.timeout
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

