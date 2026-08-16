extends StaticBody2D

@onready var collision_gate: CollisionShape2D = $CollisionGate
@onready var collision_area: CollisionShape2D = $PlayerArea/CollisionArea
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var poof_particle: CPUParticles2D = $PoofParticle

var all_johnnies = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_area_body_entered(body: Node2D) -> void:
	collision_area.set_deferred("disabled", true)
	fill_up()


func fill_up():
	var johnny_count = VariableManager.johnnies
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
		collision_gate.disabled = true
		collision_area.disabled = true
		#visible = false
		sprite_2d.visible = false
		progress_bar.visible = false
		poof_particle.emitting = true
