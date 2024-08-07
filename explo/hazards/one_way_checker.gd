extends StaticBody2D

func _on_way_check_body_entered(body):
	set_collision_layer_value(3, false)


func _on_player_detector_body_exited(body):
	set_collision_layer_value(3, true)
