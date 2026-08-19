extends StaticBody2D

@onready var lock_container: GridContainer = $LockContainer
@onready var collision_gate: CollisionShape2D = $CollisionGate
@onready var collision_area: CollisionShape2D = $PlayerArea/CollisionArea
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var poof_particle: CPUParticles2D = $PoofParticle

@export var always_closed = false
@export var force_full = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if always_closed:
		VariableManager.opened_w5_gate = false
		VariableManager.save_variables()
		
	if VariableManager.opened_w5_gate:
		collision_gate.disabled = true
		collision_area.disabled = true
		sprite_2d.visible = false
		lock_container.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_area_body_entered(body: Node2D) -> void:
	collision_area.set_deferred("disabled", true)
	animate_opening()


func animate_opening():
	var keys_collected = VariableManager.level_keys.size()
	
	if force_full:
		keys_collected = 16
	var will_open = true
	
	await get_tree().create_timer(0.150).timeout
	for child in lock_container.get_children():
		if keys_collected > 0:
			child.visible = true
			#child.modulate = Color(18.892, 18.892, 18.892)
			keys_collected -= 1
			await get_tree().create_timer(0.166).timeout
		else:
			will_open = false
		print("still doing this")
	
	if will_open:
		await get_tree().create_timer(0.834).timeout
		collision_gate.disabled = true
		collision_area.disabled = true
		sprite_2d.visible = false
		lock_container.visible = false
		poof_particle.emitting = true
		
		VariableManager.opened_w5_gate = true
		
		VariableManager.save_variables()
	
	
