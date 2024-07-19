extends StaticBody2D

@export var king_block = false

@onready var delay_timer = $DelayTimer
@onready var block_detector = $BlockDetector
@onready var collision_shape = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if king_block and Input.is_action_just_pressed("musR"):
		activate_dissablock(3)


func activate_dissablock(new_time):
	delay_timer.wait_time = new_time
	delay_timer.start()


func _on_delay_timer_timeout():
	var side_blocks = block_detector.get_overlapping_bodies()
	if side_blocks:
		for block in side_blocks:
			if block.has_method("activate_dissablock"):
				block.activate_dissablock(delay_timer.wait_time)
	collision_shape.set_deferred("disabled", true)
	queue_free() # Erstatt med animasjon pls
