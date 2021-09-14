extends BaseOptionsContainer

func _init():
	# Do something with 'e'.
	_options_map = {
		Types.DisplayMode.BORDER:"DISPLAY_MODE_BORDER",
		Types.DisplayMode.FULLSCREEN:"DISPLAY_MODE_FULLSCREEN",
		Types.DisplayMode.BORDERLESS:"DISPLAY_MODE_BORDERLESS",
	}

