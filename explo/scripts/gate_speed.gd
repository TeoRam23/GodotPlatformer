extends StaticBody2D

@onready var collision_gate: CollisionShape2D = $CollisionGate
@onready var player_area: Area2D = $PlayerArea
@onready var collision_area: CollisionShape2D = $PlayerArea/CollisionArea
@onready var color_rect: ColorRect = $ColorRect
@onready var poof_particle: CPUParticles2D = $PoofParticle

@onready var timer_short: Timer = $TimerShort
@onready var timer_long: Timer = $TimerLong

@export var always_closed = false
@export var force_full = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if always_closed:
		VariableManager.opened_speed_gate = false
		VariableManager.save_variables()
		
	if VariableManager.opened_speed_gate:
		collision_gate.disabled = true
		collision_area.disabled = true
		color_rect.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_area_body_entered(body: Node2D) -> void:
	collision_area.set_deferred("disabled", true)
	if VariableManager.end_time == 0.0 and not force_full:
		return
	timer_short.start()
	await timer_short.timeout
	color_rect.color = Color(1.0, 1.0, 1.0, 1.0)
	timer_long.start()
	await timer_long.timeout
	
	open()
	
func open():
	collision_gate.disabled = true
	color_rect.visible = false
	
	poof_particle.emitting = true
	
	VariableManager.opened_speed_gate = true
	VariableManager.save_variables()
