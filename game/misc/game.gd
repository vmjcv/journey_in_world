extends Node

func _ready():
	_init_game()


func _init_game():
	# 设置语言
	var cur_language = Settings.get_value(Settings.GAME_LANGUAGE, Config.GAME_LANGUAGE)
	print(cur_language)
	if cur_language:
		TranslationServer.set_locale(cur_language)
	
	# 设置快捷键
	var _input_map = Settings.get_value(Settings.INPUT_MAP, Config.INPUT_MAP)
	if _input_map:
		# 设置快捷键
		for action_name in _input_map:
			InputMap.action_erase_events(action_name)
			for event in _input_map[action_name]:
				InputMap.action_add_event(action_name, event)
	
	# 设置分辨率
	var cur_resolution = Settings.get_value(Settings.RESOLUTION, Config.RESOLUTION)
	if cur_resolution:
		var window_size = Utils.get_size_from_resolution_enum(cur_resolution)
		OS.window_size = window_size
	
	# 设置是否全屏
	var cur_display_mode = Settings.get_value(Settings.DISPLAY_MODE, Config.DISPLAY_MODE)
	if cur_display_mode:
		Utils.change_display_mode(cur_display_mode)
	
	OS.center_window()
