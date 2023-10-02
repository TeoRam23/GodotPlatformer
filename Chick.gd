extends Area2D


func _on_body_entered(body): #når en body er inni kyllingen
	queue_free() #sletter kyllingen neste gang det er mulig
	var chicks = get_tree().get_nodes_in_group("Chocks") #får data om gruppen "Chocks", som alle kyllinger er i
	if chicks.size() == 1:
		Events.level_completed.emit() #sender "level_completed" til world
