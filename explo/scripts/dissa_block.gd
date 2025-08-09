extends StaticBody2D

@export var dissa_id = 0

@onready var delay_timer = $DelayTimer
@onready var block_detector = $BlockDetector
@onready var collision_shape = $CollisionShape2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var pump_particle = $PumpParticle

# Called when the node enters the scene tree for the first time.
func _ready():
	var stage = get_tree().current_scene.name
	
	var world_number = stage.split()[0]
	
	material.set("shader_parameter/parent_id", int(world_number))
	#pump_particle.material.set("shader_parameter/parent_id", int(world_number))


func activate_dissablock(new_time):
	delay_timer.wait_time = new_time
	delay_timer.start()


func _on_delay_timer_timeout():
	var side_blocks = block_detector.get_overlapping_bodies()
	if side_blocks:
		for block in side_blocks:
			if block.has_method("activate_dissablock") and block.get_instance_id() != self.get_instance_id():
				block.activate_dissablock(delay_timer.wait_time)
	#collision_shape.set_deferred("disabled", true)d
	
	animate_dissing()
	#queue_free() # Erstatt med animasjon pls

func animate_dissing():
	collision_shape.disabled = true
	animated_sprite.play("dissapump")



func _on_animated_sprite_2d_animation_finished():
	animated_sprite.visible = false
	#print("fred")

func _on_pump_particle_finished():
	queue_free()
	#print("finito")


func _on_animated_sprite_2d_frame_changed():
	if animated_sprite.frame == 7:
		pump_particle.emitting = true
