extends Node

signal level_completed

signal pls_shake
signal pls_camera_limit
signal pls_set_wrap
signal pls_request_wrap
signal pls_reset_teleport
signal pls_activate_ender
signal pls_player_died
signal pls_kill_player
signal pls_resetting_level
signal pls_johnny_collected
signal pls_share_title
signal pls_general_leaving
signal pls_low_gravity
signal pls_enter_extra
signal pls_save_settings_yall

func projectile_hit():
	pls_shake.emit()

func set_camera_limit(rd, lu):
	pls_camera_limit.emit(rd, lu)

func set_wrapping(rd, lu, wr_horz, wr_vert):
	pls_set_wrap.emit(rd, lu,wr_horz, wr_vert)

func request_wrap(requester):
	pls_request_wrap.emit(requester)

func reset_teleporters():
	pls_reset_teleport.emit()

func activate_ender():
	pls_activate_ender.emit()

func player_died():
	pls_player_died.emit()
	
func kill_player():
	pls_kill_player.emit()

func resetting_level():
	pls_resetting_level.emit()

func johnny_collected():
	pls_johnny_collected.emit()

func share_title(title):
	pls_share_title.emit(title)

func general_leaving():
	pls_general_leaving.emit()

func low_gravity():
	pls_low_gravity.emit()

func enter_extra():
	pls_enter_extra.emit()

func save_settings_yall():
	pls_save_settings_yall.emit()
