extends Area2D

@export var air_strength_p = 676.2
@export var air_strength_o = 710.0

@onready var air_shap = $CollisionShape2D2

@onready var particles_2d = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	set_particle_vars()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	give_air(delta)



func give_air(delta):
	if get_overlapping_bodies():
		var bodies = get_overlapping_bodies()
		for bod in bodies:
			if bod.is_in_group("moved_by_air"):
				if bod.is_in_group("player"):
					# vet ikke om dette blir rett, eller om det virker på projectile og busker
					# lykke til fremtidsmeg...
					# takk... dette blir ikke rett, når man drar opp og ned skal man ikke komme lenger opp eller ned, men med dette gjør man det
					# ??? er kommentaren over utdatert? det ser ut til å virke som det skal tror jeg???
					print("giving to player")
					bod.prevelocity.y -= gravity * bod.movement_data.gravity_scale * delta # dette virker ikke
					bod.prevelocity.y -= air_strength_p * delta # dette virker ikke
					#bod.prevelocity.y -= 1500 * delta #dette var en test
					#print("play: ",(gravity * bod.movement_data.gravity_scale) + air_strength_p)
					#bod.prevelocity.y -= 1100 * delta
					bod.hot_air = true
					#if bod.prevelocity.y > 0 or 1==1:
						#bod.prevelocity.y -= 1600 * delta
					#else:
						#bod.prevelocity.y -= 1250 * delta
						
						
					#if bod.prevelocity.y > 0:
						#bod.prevelocity.y -= 2200 * delta
					#else:
						#bod.prevelocity.y -= 1250 * delta
						
				else:
					# dette er et forsøk på å gjøre projectile likt splodey, men jeg ga opp, bra nok
					#if bod.is_in_group("projectile"):
						## den første er for å kanselere gravitasjonen, den andre for å legge til velocetey
						#bod.velocity.y -= gravity * bod.gravity_scale * delta
						#
						#bod.velocity.y -= air_strength_o * delta
						##bod.velocity.y -= 600 * delta
					#else:
					
					# den første er for å kanselere gravitasjonen, den andre for å legge til velocetey
					#bod.velocity.y -= air_strength * delta
					

					bod.velocity.y -= gravity * bod.gravity_scale * delta
					bod.velocity.y -= air_strength_o * delta
					
					#bod.velocity.y -= 1500 * delta #dette var en test
					#print("obj: ",(gravity * bod.gravity_scale) + air_strength_o)
					#if bod.velocity.y > 0:
						#bod.velocity.y -= air_strength * delta
					#else:
						#bod.velocity.y -= air_strength * delta




func _on_body_entered(body):
	if body.is_in_group("moved_by_air"):
		if body.is_in_group("player"):
			body.prevelocity.y -= gravity * body.movement_data.gravity_scale / 60
			body.prevelocity.y -= air_strength_p / 60
		else:
			body.velocity.y -= gravity * body.gravity_scale / 60
			body.velocity.y -= air_strength_o / 60


func _on_body_exited(body):
	if body.is_in_group("moved_by_air"):
		if body.is_in_group("player"):
			body.prevelocity.y += gravity * body.movement_data.gravity_scale / 60
			body.prevelocity.y += air_strength_p / 60
		else:
			body.velocity.y += gravity * body.gravity_scale / 60
			body.velocity.y += air_strength_o / 60


func set_particle_vars():
	var air_shape = get_node_or_null("CollisionShape2D")
	
	if air_shape:
		var shape = air_shape.shape.get_rect()
		
		particles_2d.emitting = true
		particles_2d.position = air_shape.position
		particles_2d.position.y += shape.end.y
		
		particles_2d.emission_rect_extents.x = shape.end.x
		
		particles_2d.lifetime = shape.end.y * 0.0109375
		
		particles_2d.amount = shape.get_area() * 0.0030517578125
		#print("am: ",particles_2d.amount)
		#print(shape.end.y)
		#print(particles_2d.lifetime)
		
		#print(particles_2d.color_ramp.colors)
		var ye = Curve.new()
		#print("the shep: ",shape.end.y)
		if shape.end.y > 4:
			
			#particles_2d.color_ramp.set_offset(0, 0.25*1.5)
			#particles_2d.color_ramp.set_offset(1, (shape.end.y*2/16 - 2)/8)
			#particles_2d.color_ramp.set_offset(0, (shape.end.y*2/16 - 6)/8)
			#particles_2d.color_ramp.set_offset(1, 1 - (1/(shape.end.y*2/16 - 2)))
			particles_2d.color_ramp.set_offset(0, ((shape.end.y*2/16) - 3)/(shape.end.y*2/16))
			#print("test: ", ((shape.end.y*2/16) - 5)/(shape.end.y*2/16), " ended: ", shape.end.y*2/16)
			#particles_2d.color_ramp.set_offset(1, 1)
			#particles_2d.color_ramp.set_offset(0, 0.99)
			#particles_2d.color_ramp.set_offset(0, shape.end.y*2/16)
			particles_2d.scale_amount_curve.set_point_offset(0, ((shape.end.y*2/16) - 5)/(shape.end.y*2/16))
			
			
			#print("off: ", particles_2d.color_ramp.offsets)
			#print("scl: ", particles_2d.scale_amount_curve.get_point_position(0))
		
		#print(particles_2d.color_ramp.set_offset(0, 0.278*1.5))
		#print(particles_2d.color_ramp.set_offset(1, 0.781))
		
		#print(shape.size)
		#print(shape.end)
		air_shape.shape
	else:
		print("*ERRORERROR*: This HOT AIR does not have a collisionshape! ", self)
