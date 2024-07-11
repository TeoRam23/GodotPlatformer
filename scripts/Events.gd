extends Node

signal level_completed

signal pls_shake

func projectile_hit():
	pls_shake.emit()
