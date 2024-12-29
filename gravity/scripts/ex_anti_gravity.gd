extends Area2D

var polygon_2d

var collision_shape = false
@onready var color_rect = $ColorRect
@onready var border_rect = $BorderRect

@onready var left_particle = $LeftParticle
@onready var right_particle = $RightParticle
@onready var box_particle = $BoxParticle

@onready var enter_node = $EnterNode
@onready var enter_particle = $EnterNode/EnterParticle
@onready var enter_orb_particle = $EnterNode/EnterOrbParticle
@onready var leave_node = $LeaveNode
@onready var leave_particle = $LeaveNode/LeaveParticle
@onready var leave_orb_particle = $LeaveNode/LeaveOrbParticle

@export var area_direction = 180.0
@export var on_top = false

func _ready():
	collision_shape = get_node_or_null("CollisionShape2D")
	set_particles()
#	if area_direction == 180 or area_direction == -180:
#		area_direction = 179.9999
	pass


func set_particles():
	if collision_shape:
		
		var shaper = collision_shape.shape.get_rect()
		var pos = collision_shape.position
		
		left_particle.emitting = true
		left_particle.amount = shaper.size.y * 0.29296875
		left_particle.emission_rect_extents.y = shaper.size.y * 0.5
		left_particle.position.y = pos.y + 24
		left_particle.position.x = (shaper.size.x * -0.5) + pos.x
		
		right_particle.emitting = true
		right_particle.amount = shaper.size.y * 0.29296875
		right_particle.emission_rect_extents.y = shaper.size.y * 0.5
		right_particle.position.y = pos.y + 24
		right_particle.position.x = (shaper.size.x * 0.5) + pos.x
		
		box_particle.emitting = true
		box_particle.amount = shaper.get_area() * 0.0104631696428571 * 0.01
		box_particle.emission_rect_extents = shaper.size * 0.5
		box_particle.position = pos
		box_particle.position.y += 16
		
		
		color_rect.visible = true
		color_rect.size = shaper.size 
		color_rect.position = pos - (shaper.size * 0.5)
		
		border_rect.visible = true
		border_rect.size = shaper.size
		border_rect.position = pos - (shaper.size * 0.5)
	else:
		print("ExAntiGravity has no collision shape! ÆÆÆÆ")


func _on_area_entered(area):
	if area.is_in_group("GravityDetector"):
		enter_node.global_position = area.global_position
		enter_particle.emitting = true
		enter_orb_particle.emitting = true

func _on_area_exited(area):
	if area.is_in_group("GravityDetector"):
		leave_node.global_position = area.global_position
		leave_particle.emitting = true
		leave_orb_particle.emitting = true
	
