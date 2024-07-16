extends Node

signal level_completed

signal pls_shake
signal pls_camera_limit
signal pls_reset_teleport
signal pls_activate_ender
signal pls_player_died

func projectile_hit():
	pls_shake.emit()

func set_camera_limit(rd, lu):
	pls_camera_limit.emit(rd, lu)

func reset_teleporters():
	pls_reset_teleport.emit()

func activate_ender():
	pls_activate_ender.emit()

func player_died():
	pls_player_died.emit()
	
