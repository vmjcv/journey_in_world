extends BaseOptionsContainer

func _init():
	# Do something with 'e'.
	_options_map = {
		Types.Resolution.SMALL:"1280 X 720",
		Types.Resolution.DEFAULT:"1920 X 1080",
		Types.Resolution.MIDDLE:"2560 X 1440",
		Types.Resolution.BIG:"3200 X 1800",
		Types.Resolution.BIG_BIG:"3840 X 2160",
	}
