extends WindowDialog
# TODO:这代码写的很烂，勉强能用，1.数据是否需要找个专门的地方存储，2.子功能其实应该放到tab的脚本中，3.声音相关的控件应该考虑全局触发器的形式触发

# -------------------------------------------------------------------------------------------------
onready var _tab_audio: Control = $MarginContainer/TabContainer/Audio
onready var _tab_grahics: Control = $MarginContainer/TabContainer/Graphics
onready var _tab_game_play: Control = $MarginContainer/TabContainer/GamePlay
onready var _tab_extra_features: Control = $MarginContainer/TabContainer/ExtraFeatures
onready var _tab_other: Control = $MarginContainer/TabContainer/Other


onready var _master_hslider: HSlider = $MarginContainer/TabContainer/Audio/VBoxContainer/Master/HSlider
onready var _music_hslider: HSlider = $MarginContainer/TabContainer/Audio/VBoxContainer/Music/HSlider
onready var _sfx_hslider: HSlider = $MarginContainer/TabContainer/Audio/VBoxContainer/SFX/HSlider

onready var _master_audio_stream_player: AudioStreamPlayer = $MarginContainer/TabContainer/Audio/VBoxContainer/Master/AudioStreamPlayer
onready var _music_audio_stream_player: AudioStreamPlayer = $MarginContainer/TabContainer/Audio/VBoxContainer/Music/AudioStreamPlayer
onready var _sfx_audio_stream_player: AudioStreamPlayer = $MarginContainer/TabContainer/Audio/VBoxContainer/SFX/AudioStreamPlayer


onready var _image_quality_checkbutton: CheckButton = $MarginContainer/TabContainer/Graphics/VBoxContainer/ImageQuality/CheckButton
onready var _resolution_options: OptionButton = $MarginContainer/TabContainer/Graphics/VBoxContainer/Resolution/OptionButton
onready var _display_mode_options: OptionButton = $MarginContainer/TabContainer/Graphics/VBoxContainer/DisplayMode/OptionButton


onready var _game_speed_options: OptionButton = $MarginContainer/TabContainer/GamePlay/VBoxContainer/GameSpeed/OptionButton
onready var _battle_preview_checkbutton: CheckButton = $MarginContainer/TabContainer/GamePlay/VBoxContainer/BattlePreview/CheckButton

onready var _fancy_movement_checkbutton: CheckButton = $MarginContainer/TabContainer/GamePlay/VBoxContainer/FacncyMovement/CheckButton
onready var _oval_hand_shape_checkbutton: CheckButton = $MarginContainer/TabContainer/GamePlay/VBoxContainer/OvalHandShape/CheckButton
onready var _card_preview_options: OptionButton = $MarginContainer/TabContainer/GamePlay/VBoxContainer/CardPreview/OptionButton
onready var _use_debug_checkbutton: CheckButton = $MarginContainer/TabContainer/GamePlay/VBoxContainer/UseDebug/CheckButton

onready var _shortcut_key_container_toggle_button: Button = $MarginContainer/TabContainer/GamePlay/VBoxContainer/ShortcutKey/ToggleButton
onready var _shortcut_key_container_reset_button: Button = $MarginContainer/TabContainer/GamePlay/VBoxContainer/ShortcutKey/ResetButton
onready var _shortcut_key_container: ScrollContainer = $MarginContainer/TabContainer/GamePlay/VBoxContainer/ShortcutKeyContainer
onready var _shortcut_key_box_list: VBoxContainer = $MarginContainer/TabContainer/GamePlay/VBoxContainer/ShortcutKeyContainer/ShortcutKeyBoxList
onready var _shortcut_key_pop_up: Popup = $MarginContainer/TabContainer/GamePlay/Popup

onready var _use_2d_checkbutton: CheckButton = $MarginContainer/TabContainer/ExtraFeatures/VBoxContainer/Use2d/CheckButton
onready var _camera_shake_checkbutton: CheckButton = $MarginContainer/TabContainer/ExtraFeatures/VBoxContainer/CameraShake/CheckButton
onready var _color_blindness_mode_options: OptionButton = $MarginContainer/TabContainer/ExtraFeatures/VBoxContainer/ColorBlindnessMode/OptionButton
onready var _user_interface_size_options: OptionButton = $MarginContainer/TabContainer/ExtraFeatures/VBoxContainer/UserInterfaceSize/OptionButton

onready var _language_options: OptionButton = $MarginContainer/TabContainer/Other/VBoxContainer/Language/OptionButton
onready var _hide_player_name_checkbutton: CheckButton = $MarginContainer/TabContainer/Other/VBoxContainer/HidePlayerName/CheckButton

onready var is_ready = true


var _game_speed_map = {
	Types.GameSpeed.DEFAULT:"GAME_SPEED_DEFAULT",
	Types.GameSpeed.SMALL:"GAME_SPEED_SMALL",
	Types.GameSpeed.MIDDLE:"GAME_SPEED_MIDDLE",
	Types.GameSpeed.BIG:"GAME_SPEED_BIG",
}

var _card_preview_map = {
	Types.CardPreview.SCALING:"CARD_PREVIEW_SCALING",
	Types.CardPreview.VIEWPORT:"CARD_PREVIEW_VIEWPORT",
	Types.CardPreview.SCALING_VIEWPORT:"CARD_PREVIEW_SCALING_VIEWPORT",
}

var _resolution_map = {
	Types.Resolution.SMALL:"1280 X 720",
	Types.Resolution.DEFAULT:"1920 X 1080",
	Types.Resolution.MIDDLE:"2560 X 1440",
	Types.Resolution.BIG:"3200 X 1800",
	Types.Resolution.BIG_BIG:"3840 X 2160",
}
var _display_mode_map = {
	Types.DisplayMode.BORDER:"DISPLAY_MODE_BORDER",
	Types.DisplayMode.FULLSCREEN:"DISPLAY_MODE_FULLSCREEN",
	Types.DisplayMode.BORDERLESS:"DISPLAY_MODE_BORDERLESS",
}



var _action_bind:PackedScene = preload("res://UI/dialogs/settings_dialog/action_node.tscn")
var _control_bind:PackedScene = preload("res://UI/dialogs/settings_dialog/control_node.tscn")
var action_nodes = {}
# 使用的是types里面的内容主要是给翻译使用
var _action_map = {
	"Card1":"CARD1",
	"Card2":"CARD2",
	"Card3":"CARD3",
	"Card4":"CARD4",
	"Card5":"CARD5",
	"ToggleGameSpeed":"TOGGLE_GAME_SPEED",
	"UseCard":"USE_CARD",
	"CancelUseCard":"CANCEL_USE_CARD",
	"Setting":"SETTING",
	"Left":"LEFT",
	"Right":"RIGHT",
	"Up":"UP",
	"Down":"DOWN",
	"ShowCards":"SHOW_CARDS",
	"ShowDrawCards":"SHOW_DRAW_CARDS",
	"ShowDiscardCards":"SHOW_DISCARD_CARDS",
	"ShowShortcutKey":"SHOW_SHORTCUT_KEY",
	"ShowMap":"SHOW_MAP",
}
var _input_map

var _color_blindness_mode_map = {
	Types.ColorBlindnessMode.DEFAULT:"COLOR_BLINDNESS_MODE_DEFAULT",
	Types.ColorBlindnessMode.GREEN:"COLOR_BLINDNESS_MODE_GREEN"
}

var _user_interface_size_map = {
	Types.UserInterfaceSize.DEFAULT:"USER_INTERFACE_SIZE_DEFAULT",
	Types.UserInterfaceSize.BIG:"USER_INTERFACE_SIZE_BIG"
}

var _locales = TranslationServer.get_loaded_locales()
var _locales_map = {
	"en":"SETTING_LANGUAGE_EN",
	"zh":"SETTING_LANGUAGE_ZH",
}

# -------------------------------------------------------------------------------------------------
func _ready():
	_update_tab()

func _update_tab():
	if is_ready:
		_update_tab_name()
		_update_audio_tab()
		_update_graphics_tab()
		_update_game_play_tab()
		_update_extra_features_tab()
		_update_other_tab()

func _update_tab_name():
	_tab_audio.name = tr("AUDIO")
	_tab_grahics.name = tr("GRAPHICS")
	_tab_game_play.name = tr("GAME_PLAY")
	_tab_extra_features.name = tr("EXTRA_FEATURES")
	_tab_other.name = tr("OTHER")

# -------------------------------------------------------------------------------------------------

func _update_audio_tab():
	_update_master_hslider()
	_update_music_hslider()
	_update_sfx_hslider()
	
func _update_master_hslider():
	var cur_master = Settings.get_value(Settings.AUDIO_MASTER, Config.AUDIO_MASTER)
	_master_hslider.value = cur_master
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(cur_master/100))
	_master_hslider.connect("value_changed",self,"_on_master_value_changed")
	
func _on_master_value_changed(value):
	Settings.set_value(Settings.AUDIO_MASTER, value)
	# TODO:更改全局音量
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value/100))
	_master_audio_stream_player.play()
	
func _update_music_hslider():
	var cur_music = Settings.get_value(Settings.AUDIO_MUSIC, Config.AUDIO_MUSIC)
	_music_hslider.value = cur_music
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(cur_music/100))
	_music_hslider.connect("value_changed",self,"_on_music_value_changed")

func _on_music_value_changed(value):
	Settings.set_value(Settings.AUDIO_MUSIC, value)
	# TODO:更改音乐音量
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value/100))
	_music_audio_stream_player.play()
	
func _update_sfx_hslider():
	var cur_sfx = Settings.get_value(Settings.AUDIO_SFX, Config.AUDIO_SFX)
	_sfx_hslider.value = cur_sfx
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(cur_sfx/100))
	_sfx_hslider.connect("value_changed",self,"_on_sfx_value_changed")

func _on_sfx_value_changed(value):
	Settings.set_value(Settings.AUDIO_SFX, value)
	# TODO:更改音效音量
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value/100))
	_sfx_audio_stream_player.play()
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------

func _update_graphics_tab():
	_update_image_quality_checkbutton()
	_update_resolution_options()
	_update_diaplay_mode_options()
	
func _update_image_quality_checkbutton():
	var cur_image_quality = Settings.get_value(Settings.IMAGE_QUALITY, Config.IMAGE_QUALITY)
	_image_quality_checkbutton.toggle_mode = true
	_image_quality_checkbutton.pressed = cur_image_quality





func _on_image_quality_checkbutton_toggled(button_pressed):
	Settings.set_value(Settings.IMAGE_QUALITY, button_pressed)
	# TODO:发出一个信号去更新内容
	
func _update_resolution_options():
	var cur_resolution = Settings.get_value(Settings.RESOLUTION, Config.RESOLUTION)
	_resolution_options.clear()
	for i in _resolution_map:
		_resolution_options.add_item(tr(_resolution_map[i]), i)
	_resolution_options.selected = _resolution_options.get_item_index(cur_resolution)

func _on_resolution_options_item_selected(id:int)->void:
	Settings.set_value(Settings.RESOLUTION, _resolution_options.get_item_id(id))
	# 分辨率改变
	var window_size = Utils.get_size_from_resolution_enum(_resolution_options.get_item_id(id))
	OS.window_size = window_size
	OS.center_window()

func _update_diaplay_mode_options():
	var cur_display_mode = Settings.get_value(Settings.DISPLAY_MODE, Config.DISPLAY_MODE)
	_display_mode_options.clear()
	for i in _display_mode_map:
		_display_mode_options.add_item(tr(_display_mode_map[i]), i)
	_display_mode_options.selected = _display_mode_options.get_item_index(cur_display_mode)

func _on_diaplay_mode_options_item_selected(id:int)->void:
	Settings.set_value(Settings.DISPLAY_MODE, _display_mode_options.get_item_id(id))
	# 显示模式改变
	Utils.change_display_mode(_display_mode_options.get_item_id(id))

# -------------------------------------------------------------------------------------------------
func _update_game_play_tab():
	_update_game_speed_options()
	_update_battle_preview_checkbutton()
	_toggle_shortcut_key_container(false)
	_init_action_controls()
	_init_shortcut_key_box_list()
	_update_fancy_movement_checkbutton()
	_update_oval_hand_shape_checkbutton()
	_update_card_preview_options()
	_update_use_debug_checkbutton()


func _update_game_speed_options():
	var cur_game_speed = Settings.get_value(Settings.GAME_SPEED, Config.GAME_SPEED)
	_game_speed_options.clear()
	for i in _game_speed_map:
		_game_speed_options.add_item(tr(_game_speed_map[i]), i)
	_game_speed_options.selected = _game_speed_options.get_item_index(cur_game_speed)

func _on_game_speed_options_item_selected(id:int)->void:
	Settings.set_value(Settings.COLOR_BLINDNESS_MODE, _game_speed_options.get_item_id(id))

func _update_battle_preview_checkbutton():
	var cur_battle_preview = Settings.get_value(Settings.BATTLE_PREVIEW, Config.BATTLE_PREVIEW)
	_battle_preview_checkbutton.toggle_mode = true
	_battle_preview_checkbutton.pressed = cur_battle_preview

func _on_battle_preview_checkbutton_toggled(button_pressed):
	Settings.set_value(Settings.BATTLE_PREVIEW, button_pressed)
	# TODO:发出一个信号去更新内容
	

func _update_fancy_movement_checkbutton():
	var cur_fancy_movement = Settings.get_value(Settings.FANCY_MOVEMENT, Config.FANCY_MOVEMENT)
	_fancy_movement_checkbutton.toggle_mode = true
	_fancy_movement_checkbutton.pressed = cur_fancy_movement

func _on_fancy_movement_checkbutton_toggled(button_pressed):
	Settings.set_value(Settings.FANCY_MOVEMENT, button_pressed)
	# TODO:发出一个信号去更新内容


func _update_oval_hand_shape_checkbutton():
	var cur_oval_hand_shape = Settings.get_value(Settings.OVAL_HAND_SHAPE, Config.OVAL_HAND_SHAPE)
	_oval_hand_shape_checkbutton.toggle_mode = true
	_oval_hand_shape_checkbutton.pressed = cur_oval_hand_shape

func _on_oval_hand_shape_checkbutton_toggled(button_pressed):
	Settings.set_value(Settings.OVAL_HAND_SHAPE, button_pressed)
	# TODO:发出一个信号去更新内容
	
func _update_use_debug_checkbutton():
	var cur_use_debug = Settings.get_value(Settings.USE_DEBUG, Config.USE_DEBUG)
	_use_debug_checkbutton.toggle_mode = true
	_use_debug_checkbutton.pressed = cur_use_debug

func _on_use_debug_checkbutton_toggled(button_pressed):
	Settings.set_value(Settings.USE_DEBUG, button_pressed)
	# TODO:发出一个信号去更新内容

func _update_card_preview_options():
	var cur_card_preview = Settings.get_value(Settings.CARD_PREVIEW, Config.CARD_PREVIEW)
	_card_preview_options.clear()
	for i in _card_preview_map:
		_card_preview_options.add_item(tr(_card_preview_map[i]), i)
	_card_preview_options.selected = _card_preview_options.get_item_index(cur_card_preview)

func _on_card_preview_options_item_selected(id:int)->void:
	Settings.set_value(Settings.CARD_PREVIEW, _card_preview_options.get_item_id(id))


func _shortcut_key_container_toggle_button_toggled(button_pressed):
	_toggle_shortcut_key_container(button_pressed)

func _toggle_shortcut_key_container(pressed):
	_shortcut_key_container.visible = pressed
	_shortcut_key_container_toggle_button.text = "-" if pressed else "+"

func _shortcut_key_container_reset_button_toggled():
	Settings.set_value(Settings.INPUT_MAP, null)
	_init_action_controls()
	_init_shortcut_key_box_list()

func _init_action_controls():
	InputMap.load_from_globals()
	# 从配置文件中加载内容
	_input_map = Settings.get_value(Settings.INPUT_MAP, Config.INPUT_MAP)
	_update_shortcut_key_to_game()
	_input_map = {}
	for action_name in Types.Actions:
		var action_list:Array = InputMap.get_action_list(action_name) #associated controlls to the action
		_input_map[action_name] = action_list

	
func _init_shortcut_key_box_list():
	# 更新所有的默认值
	Utils.remove_all_child(_shortcut_key_box_list)
	action_nodes = {}
	for action_name in Types.Actions:
		var action_node:VBoxContainer = _action_bind.instance()
		_shortcut_key_box_list.add_child(action_node)
		action_nodes[action_name] = action_node #Save node for easier access
		var cur_name:Label = action_node.find_node("Name") #Name of actions
		var cur_add:Button = action_node.find_node("AddAction") #Used for adding new ControlBind
		cur_name.text = tr(_action_map[action_name])
		cur_add.connect("pressed", self, "add_control", [action_name])
		_update_control_list(action_name)
	_update_shortcut_key_to_game()

	
func add_control(action_name)->void:
	_shortcut_key_pop_up.popup_centered()
	yield(_shortcut_key_pop_up, "new_control")
	if _shortcut_key_pop_up.new_event == null:
		return
	var event:InputEvent = _shortcut_key_pop_up.new_event
	_input_map[action_name].push_back(event)
	_update_shortcut_key_to_game()
	_update_control_list(action_name)


func _update_control_list(action_name):
	var action_control = action_nodes[action_name]
	var action_data = _input_map[action_name]
	Utils.remove_all_child_in_group(action_control,"input_event_node")
	# 增加节点表现
	for cur_input in action_data:
		var event_node = _control_bind.instance()
		action_control.add_child(event_node)
		var cur_name:Label = event_node.find_node("Name")
		var cur_remove:Button = event_node.find_node("RemoveAction")
		cur_name.text = tr(get_inpue_event_name(cur_input))
		cur_remove.connect("pressed", self, "remove_control", [[action_name, cur_input]])

func remove_control(Bind:Array)->void:
	var action_name:String = Bind[0]
	var cur_input:InputEvent = Bind[1]
	var index:int = _input_map[action_name].find(cur_input)
	_input_map[action_name].remove(index)
	_update_shortcut_key_to_game()
	_update_control_list(action_name)


func get_inpue_event_name(event:InputEvent)->String:
	var text:String = ""
	if event is InputEventKey:
		text = tr("KEY_BOARD")+": " + event.as_text()
	elif event is InputEventJoypadButton:
		text = "Gamepad: "
		if Input.is_joy_known(event.device):
			text+= str(Input.get_joy_button_string(event.button_index))
		else:
			text += "Btn. " + str(event.button_index)
	elif event is InputEventJoypadMotion:
		text = "Gamepad: "
		var stick: = ''
		if Input.is_joy_known(event.device):
			stick = str(Input.get_joy_axis_string(event.axis))
			text+= stick + " "
		else:
			text += "Axis: " + str(event.axis) + " "
		
		if !stick.empty():	#known
			var value:int = round(event.axis_value)
			if stick.ends_with('X'):
				if value > 0:
					text += 'Rigt'
				else:
					text += 'Left'
			else:
				if value > 0:
					text += 'Down'
				else:
					text += 'Up'
		else:
			text += str(round(event.axis_value))
	return text

	
func _update_shortcut_key_to_game():
	if _input_map:
		# 设置快捷键
		for action_name in _input_map:
			InputMap.action_erase_events(action_name)
			for event in _input_map[action_name]:
				InputMap.action_add_event(action_name, event)	
		Settings.set_value(Settings.INPUT_MAP, _input_map)

# -------------------------------------------------------------------------------------------------
func _update_extra_features_tab():
	_update_use2d_checkbutton()
	_update_camera_shake_checkbutton()
	_update_color_blindness_mode_options()
	_update_user_interface_size_options()

func _update_use2d_checkbutton():
	var use_2d = Settings.get_value(Settings.USE_2D, Config.USE_2D)
	_use_2d_checkbutton.toggle_mode = true
	_use_2d_checkbutton.pressed = use_2d

func _on_use2d_checkbutton_toggled(button_pressed):
	Settings.set_value(Settings.USE_2D, button_pressed)
	# TODO:发出一个信号去更新内容

func _update_camera_shake_checkbutton():
	var camera_shake = Settings.get_value(Settings.CAMERA_SHAKE, Config.CAMERA_SHAKE)
	_camera_shake_checkbutton.toggle_mode = true
	_camera_shake_checkbutton.pressed = camera_shake


func _on_camera_shake_checkbutton_toggled(button_pressed):
	Settings.set_value(Settings.CAMERA_SHAKE, button_pressed)
	# TODO:发出一个信号去更新内容

func _update_color_blindness_mode_options():
	var cur_color_blindness_mode = Settings.get_value(Settings.COLOR_BLINDNESS_MODE, Config.COLOR_BLINDNESS_MODE)
	_color_blindness_mode_options.clear()
	for i in _color_blindness_mode_map:
		_color_blindness_mode_options.add_item(tr(_color_blindness_mode_map[i]), i)
	_color_blindness_mode_options.selected = _color_blindness_mode_options.get_item_index(cur_color_blindness_mode)

func _on_color_blindness_mode_options_item_selected(id:int)->void:
	Settings.set_value(Settings.COLOR_BLINDNESS_MODE, _color_blindness_mode_options.get_item_id(id))

func _update_user_interface_size_options():
	var cur_user_interface_size_options = Settings.get_value(Settings.USER_INTERFACE_SIZE, Config.USER_INTERFACE_SIZE)
	_user_interface_size_options.clear()
	for i in _user_interface_size_map:
		_user_interface_size_options.add_item(tr(_user_interface_size_map[i]), i)
	_user_interface_size_options.selected = _user_interface_size_options.get_item_index(cur_user_interface_size_options)

func _on_user_interface_size_options_item_selected(id:int)->void:
	Settings.set_value(Settings.USER_INTERFACE_SIZE, _user_interface_size_options.get_item_id(id))

# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
func _update_other_tab():
	_update_languages_options()
	_update_hide_player_name_checkbutton()

func _update_languages_options():
	# TODO:需要找个地方初始化项目的语言
	var cur_language = Settings.get_value(Settings.GAME_LANGUAGE, Config.GAME_LANGUAGE)
	if not cur_language:
		cur_language = TranslationServer.get_locale()

	_language_options.clear()
	_locales = TranslationServer.get_loaded_locales()
	var index = 0
	for lang in _locales:
		_language_options.add_item(tr(_locales_map[lang]), index)
		index = index + 1
	_language_options.selected = _language_options.get_item_index(_locales.find(cur_language))

func _on_language_options_item_selected(id:int)->void:
	var cur_local = _locales[_language_options.get_item_id(id)]
	Settings.set_value(Settings.GAME_LANGUAGE, cur_local)
	TranslationServer.set_locale(cur_local)

func _update_hide_player_name_checkbutton():
	var hide_player_name = Settings.get_value(Settings.HIDE_PLAYER_NAME, Config.HIDE_PLAYER_NAME)
	_hide_player_name_checkbutton.toggle_mode = true
	_hide_player_name_checkbutton.pressed = hide_player_name

func _on_hide_player_name_checkbutton_toggled(button_pressed):
	Settings.set_value(Settings.HIDE_PLAYER_NAME, button_pressed)
	# TODO:发出一个信号去更新内容
# -------------------------------------------------------------------------------------------------


func _notification(what):
	match what:
		NOTIFICATION_TRANSLATION_CHANGED:
			_update_tab()
