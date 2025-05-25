extends Area2D

@export var left_border = true
@export var right_border = true

var polygon_2d

var collision_shape = false
@onready var color_rect = $GroupInvisibles/ColorRect
@onready var border_rect = $GroupInvisibles/BorderRect
@onready var line_left = $GroupInvisibles/LineLeft
@onready var line_right = $GroupInvisibles/LineRight

@onready var left_particle = $GroupInvisibles/LeftParticle
@onready var right_particle = $GroupInvisibles/RightParticle
@onready var box_particle = $GroupInvisibles/BoxParticle

@onready var enter_node = $EnterNode
@onready var enter_particle = $EnterNode/EnterParticle
@onready var enter_orb_particle = $EnterNode/EnterOrbParticle
@onready var leave_node = $LeaveNode
@onready var leave_particle = $LeaveNode/LeaveParticle
@onready var leave_orb_particle = $LeaveNode/LeaveOrbParticle

@onready var group_invisibles = $GroupInvisibles

@export var area_direction = 180.0
@export var on_top = false

var shaper = false
var pos = Vector2.ZERO

func _ready():
	collision_shape = get_node_or_null("CollisionShape2D")
	set_particles()
	group_invisibles.visible = true
#	if area_direction == 180 or area_direction == -180:
#		area_direction = 179.9999
	pass


func set_particles():
	if collision_shape:
		
		shaper = collision_shape.shape.get_rect()
		pos = collision_shape.position
		
		left_particle.emitting = left_border
		left_particle.amount = shaper.size.y * 0.29296875
		left_particle.emission_rect_extents.y = shaper.size.y * 0.5 -12
		left_particle.position.y = pos.y + 24
		left_particle.position.x = (shaper.size.x * -0.5) + pos.x
		
		right_particle.emitting = right_border
		right_particle.amount = shaper.size.y * 0.29296875
		right_particle.emission_rect_extents.y = shaper.size.y * 0.5
		right_particle.position.y = pos.y + 24
		right_particle.position.x = (shaper.size.x * 0.5) + pos.x
		
		box_particle.emitting = true
		if shaper.get_area() * 0.0104631696428571 * 0.01 < 1:
			box_particle.amount = 1
		else:
			box_particle.amount = shaper.get_area() * 0.0104631696428571 * 0.02
		box_particle.emission_rect_extents.x = shaper.size.x * 0.5
		box_particle.emission_rect_extents.y = shaper.size.y * 0.5 - 8
		box_particle.position = pos
		box_particle.position.y += 32
		
		
		color_rect.visible = true
		color_rect.size = shaper.size 
		color_rect.position = pos - (shaper.size * 0.5)
		
		#border_rect.visible = true
		#border_rect.size = shaper.size - Vector2(1,1)
		#border_rect.position = (pos - (shaper.size * 0.5))
		#print("border1: ", border_rect.position)
		##border_rect.position += Vector2(0.5,0.5)
		#print("border2: ", border_rect.position)
		line_left.visible = left_border
		line_left.set_point_position(0, Vector2(pos.x - (shaper.size.x*0.5)+0.5,pos.y - (shaper.size.y*0.5)))
		line_left.set_point_position(1, Vector2(pos.x - (shaper.size.x*0.5)+0.5,pos.y + (shaper.size.y*0.5)))
		line_right.visible = right_border
		line_right.set_point_position(0, Vector2(pos.x + (shaper.size.x*0.5)-0.5,pos.y + (shaper.size.y*0.5)))
		line_right.set_point_position(1, Vector2(pos.x + (shaper.size.x*0.5)-0.5,pos.y - (shaper.size.y*0.5)))
		
	else:
		print("ExAntiGravity has no collision shape! ÆÆÆÆ")


func _on_area_entered(area):
	if area.is_in_group("GravityDetector"):
		if area.get_parent().up_direction.y == 1:
			return
		enter_node.global_position = area.global_position
		enter_particle.emitting = true
		enter_orb_particle.emitting = true

func _on_area_exited(area):
	if area.is_in_group("GravityDetector"):
		if area.get_overlapping_areas():
			#print("returning")
			return
		#print("NOT returning")
		leave_node.global_position = area.global_position
		leave_particle.emitting = true
		leave_orb_particle.emitting = true
	


