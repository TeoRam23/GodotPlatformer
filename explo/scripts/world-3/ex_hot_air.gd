extends Area2D

@export var air_strength_p = 676.2
@export var air_strength_o = 710

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
					
					bod.prevelocity.y -= gravity * bod.movement_data.gravity_scale * delta # dette virker ikke
					bod.prevelocity.y -= air_strength_p * delta # dette virker ikke
					#bod.hot_air = true
					#if bod.prevelocity.y > 0 or 1==1:
						#bod.prevelocity.y -= 1600 * delta
					#else:
						#bod.prevelocity.y -= 1250 * delta
						
						
					#if bod.prevelocity.y > 0:
						#bod.prevelocity.y -= 2200 * delta
					#else:
						#bod.prevelocity.y -= 1250 * delta
						
				else:
					print(bod.name)
					# den første er for å kanselere gravitasjonen, den andre for å legge til velocetey
					bod.velocity.y -= gravity * bod.gravity_scale * delta
					#bod.velocity.y -= air_strength * delta
					bod.velocity.y -= air_strength_o * delta
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
