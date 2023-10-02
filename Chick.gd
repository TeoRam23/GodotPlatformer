extends Area2D


func _on_body_entered(body):
	queue_free()
	var chicks = get_tree().get_nodes_in_group("Chocks")
	if chicks.size() == 1:
		Events.level_completed.emit()
