extends Area2D

@export var teleport_id = 0
var porter_crime

var broken = false

var port_amount = 0
@onready var death_timer = $DeathTimer
@onready var wait_timer = $WaitTimer
@onready var collision_shape_2d = $CollisionShape2D
@onready var sheen_sprite = $SheenSprite

@onready var porting = $Porting
@onready var audio_teleport: AudioStreamPlayer = $AudioTeleport

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.pls_reset_teleport.connect(reset_my_amount)
	
	var porters = get_tree().get_nodes_in_group("teleporter")
	for port in porters:
		if port.teleport_id == teleport_id:
			if port != self and (not port.porter_crime or port.porter_crime == self):
				porter_crime = port
				#print("found ya")
				break
	if !porter_crime:
		modulate = Color(0.79, 0.79, 0.79, 0.604)
	
	rotate_sheen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if !broken and porter_crime:
		if !death_timer.time_left:
			if port_amount > 40:
				body.i_died()
				Events.reset_teleporters()
				return

			death_timer.start()
		else:
			port_amount += 1
		
		porting.emitting = true
		body.global_position = porter_crime.global_position
		porter_crime.break_porter()
		audio_teleport.playing = true

func _on_death_timer_timeout():
	wait_timer.start()
func _on_wait_timer_timeout():
	reset_my_amount()
	
	
func _on_body_exited(body):
	broken = false


func break_porter():
	porting.emitting = true
	broken = true


func reset_my_amount():
	port_amount = 0




func rotate_sheen():
	var tween = create_tween()
	tween.tween_property(sheen_sprite, "rotation", -PI*2, 1)
	await tween.finished
	sheen_sprite.rotation = 0
	rotate_sheen()
