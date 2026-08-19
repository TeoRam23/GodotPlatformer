extends StaticBody2D

@onready var collision_gate: CollisionShape2D = $CollisionGate
@onready var collision_area: CollisionShape2D = $PlayerArea/CollisionArea
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var poof_particle: CPUParticles2D = $PoofParticle

var all_johnnies = 20

@export var always_closed = false
@export var force_full = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if always_closed:
		VariableManager.opened_johnny_gate = false
		VariableManager.save_variables()
		
	if VariableManager.opened_johnny_gate:
		collision_gate.disabled = true
		collision_area.disabled = true
		sprite_2d.visible = false
		progress_bar.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_area_body_entered(body: Node2D) -> void:
	collision_area.set_deferred("disabled", true)
	fill_up()


func fill_up():
	var johnny_count = VariableManager.johnnies
	print(johnny_count)
	
	if force_full:
		johnny_count = 41
	
	for j in johnny_count:
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		progress_bar.value += 2
		if j >= 20: break
	
	if johnny_count >= all_johnnies:
		await get_tree().create_timer(0.333).timeout
		#visible = false
		collision_gate.disabled = true
		collision_area.disabled = true
		sprite_2d.visible = false
		progress_bar.visible = false
		poof_particle.emitting = true
		
		VariableManager.opened_johnny_gate = true
		
		VariableManager.save_variables()
