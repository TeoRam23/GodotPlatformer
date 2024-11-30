extends Area2D


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
			if bod.is_in_group("player"):
				# vet ikke om dette blir rett, eller om det virker på projectile og busker
				# lykke til fremtidsmeg...
				if bod.prevelocity.y > 0:
					bod.prevelocity.y -= 1600 * delta
				else:
					bod.prevelocity.y -= 1250 * delta



