extends BaseOptionsContainer

func _init():
	# Do something with 'e'.
	_options_map = {
		Types.GameSpeed.DEFAULT:"GAME_SPEED_DEFAULT",
		Types.GameSpeed.SMALL:"GAME_SPEED_SMALL",
		Types.GameSpeed.MIDDLE:"GAME_SPEED_MIDDLE",
		Types.GameSpeed.BIG:"GAME_SPEED_BIG",
	}
