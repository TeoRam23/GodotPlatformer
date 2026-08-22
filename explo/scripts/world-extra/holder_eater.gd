extends Node2D


var our_player: CharacterBody2D
var mid_pos = Vector2(16, -13)
@onready var projectile_collision_shape = $ProjectileCollisionShape
@onready var kill_timer = $KillTimer
@onready var holder_anim: AnimatedSprite2D = $HolderAnim
@onready var audio_hold: AudioStreamPlayer = $AudioHold
@onready var audio_timer: Timer = $AudioTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(kill_timer.time_left)
	pass


func _on_player_area_body_entered(body):
	our_player = body
	body.velocity = Vector2.ZERO
	body.prevelocity = Vector2.ZERO
	body.position = global_position# + mid_pos
	body.position.y += 3
	body.disable_player(false)
	
	kill_timer.paused = false
	kill_timer.start()
	holder_anim.play("close")
	audio_timer.start()
	projectile_collision_shape.set_deferred("disabled", false)
	

func explode():
	#print("yup, sploded AAAAAAAAAAAAAAAAAAAAAA")
	if our_player is CharacterBody2D:
		#print("also yup")
		our_player.enable_player()
	reset_me()
	
	
func reset_me():
	our_player = null
	kill_timer.paused = true
	audio_hold.stop()
	audio_timer.stop()
	#kill_timer.time_left = kill_timer.wait_time
	holder_anim.play_backwards("close")
	projectile_collision_shape.set_deferred("disabled", true)


func _on_kill_timer_timeout():
	if our_player is CharacterBody2D:
		our_player.enable_player()
		reset_me()
		Events.kill_player(true)


func _on_audio_timer_timeout() -> void:
	audio_hold.play()
