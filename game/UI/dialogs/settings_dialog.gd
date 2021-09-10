extends WindowDialog

# -------------------------------------------------------------------------------------------------
#const THEME_DARK_INDEX 	:= 0
#const THEME_LIGHT_INDEX := 1
#
#const AA_NONE_INDEX 		:= 0
#const AA_OPENGL_HINT_INDEX 	:= 1
#const AA_TEXTURE_FILL_INDEX := 2

# -------------------------------------------------------------------------------------------------
onready var _tab_audio: Control = $MarginContainer/TabContainer/Audio
onready var _tab_grahics: Control = $MarginContainer/TabContainer/Graphics
onready var _tab_game_play: Control = $MarginContainer/TabContainer/GamePlay
onready var _tab_extra_features: Control = $MarginContainer/TabContainer/ExtraFeatures
onready var _tab_other: Control = $MarginContainer/TabContainer/Other


onready var _game_speed_options: OptionButton = $MarginContainer/TabContainer/GamePlay/VBoxContainer/GameSpeed/OptionButton
onready var _battle_preview_checkbutton: CheckButton = $MarginContainer/TabContainer/GamePlay/VBoxContainer/BattlePreview/CheckButton


onready var _use_2d_checkbutton: CheckButton = $MarginContainer/TabContainer/ExtraFeatures/VBoxContainer/Use2d/CheckButton
onready var _camera_shake_checkbutton: CheckButton = $MarginContainer/TabContainer/ExtraFeatures/VBoxContainer/CameraShake/CheckButton
onready var _color_blindness_mode_options: OptionButton = $MarginContainer/TabContainer/ExtraFeatures/VBoxContainer/ColorBlindnessMode/OptionButton
onready var _user_interface_size_options: OptionButton = $MarginContainer/TabContainer/ExtraFeatures/VBoxContainer/UserInterfaceSize/OptionButton

onready var _language_options: OptionButton = $MarginContainer/TabContainer/Other/VBoxContainer/Language/OptionButton
onready var _hide_player_name_checkbutton: CheckButton = $MarginContainer/TabContainer/Other/VBoxContainer/HidePlayerName/CheckButton


var _game_speed_map = {
	Types.GameSpeed.DEFAULT:"GAME_SPEED_DEFAULT",
	Types.GameSpeed.SMALL:"GAME_SPEED_SMALL",
	Types.GameSpeed.MIDDLE:"GAME_SPEED_MIDDLE",
	Types.GameSpeed.BIG:"GAME_SPEED_BIG",
}

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

#onready var _pressure_sensitivity: SpinBox = $MarginContainer/TabContainer/General/VBoxContainer/PressureSensitivity/PressureSensitivity
#onready var _brush_size: SpinBox = $MarginContainer/TabContainer/General/VBoxContainer/DefaultBrushSize/DefaultBrushSize
#onready var _brush_color: ColorPickerButton = $MarginContainer/TabContainer/General/VBoxContainer/DefaultBrushColor/DefaultBrushColor
#onready var _canvas_color: ColorPickerButton = $MarginContainer/TabContainer/General/VBoxContainer/DefaultCanvasColor/DefaultCanvasColor
#onready var _project_dir: LineEdit = $MarginContainer/TabContainer/General/VBoxContainer/DefaultSaveDir/DefaultSaveDir
#onready var _theme: OptionButton = $MarginContainer/TabContainer/Appearance/VBoxContainer/Theme/Theme
#onready var _aa_mode: OptionButton = $MarginContainer/TabContainer/Rendering/VBoxContainer/AntiAliasing/AntiAliasing
#onready var _foreground_fps: SpinBox = $MarginContainer/TabContainer/Rendering/VBoxContainer/TargetFramerate/TargetFramerate
#onready var _background_fps: SpinBox = $MarginContainer/TabContainer/Rendering/VBoxContainer/BackgroundFramerate/BackgroundFramerate
#onready var _general_restart_label: Label = $MarginContainer/TabContainer/General/VBoxContainer/RestartLabel
#onready var _appearence_restart_label: Label = $MarginContainer/TabContainer/Appearance/VBoxContainer/RestartLabel
#onready var _rendering_restart_label: Label = $MarginContainer/TabContainer/Rendering/VBoxContainer/RestartLabel

#onready var _brush_rounding_options: OptionButton = $MarginContainer/TabContainer/Rendering/VBoxContainer/BrushRounding/OptionButton

# -------------------------------------------------------------------------------------------------
func _ready():
	_update_tab()

func _update_tab():
	_update_tab_name()
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
func _update_game_play_tab():
	_update_game_speed_options()
	_update_battle_preview_checkbutton()


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
#	_set_values()
#
## -------------------------------------------------------------------------------------------------
#func _set_values() -> void:
#	var brush_size = Settings.get_value(Settings.GENERAL_DEFAULT_BRUSH_SIZE, Config.DEFAULT_BRUSH_SIZE)
#	var brush_color = Settings.get_value(Settings.GENERAL_DEFAULT_BRUSH_COLOR, Config.DEFAULT_BRUSH_COLOR)
#	var canvas_color = Settings.get_value(Settings.GENERAL_DEFAULT_CANVAS_COLOR, Config.DEFAULT_CANVAS_COLOR)
#	var project_dir = Settings.get_value(Settings.GENERAL_DEFAULT_PROJECT_DIR, "")
#	var theme = Settings.get_value(Settings.APPEARANCE_THEME, Types.UITheme.DARK)
#	var aa_mode = Settings.get_value(Settings.RENDERING_AA_MODE, Config.DEFAULT_AA_MODE)
#	var locale = Settings.get_value(Settings.GENERAL_LANGUAGE, "en")
#	var foreground_fps = Settings.get_value(Settings.RENDERING_FOREGROUND_FPS, Config.DEFAULT_FOREGROUND_FPS)
#	var background_fps = Settings.get_value(Settings.RENDERING_BACKGROUND_FPS, Config.DEFAULT_BACKGROUND_FPS)
#	var pressure_sensitivity = Settings.get_value(Settings.GENERAL_PRESSURE_SENSITIVITY, Config.DEFAULT_PRESSURE_SENSITIVITY)
#
#	match theme:
#		Types.UITheme.DARK: _theme.selected = THEME_DARK_INDEX
#		Types.UITheme.LIGHT: _theme.selected = THEME_LIGHT_INDEX
#	match aa_mode:
#		Types.AAMode.NONE: _aa_mode.selected = AA_NONE_INDEX
#		Types.AAMode.OPENGL_HINT: _aa_mode.selected = AA_OPENGL_HINT_INDEX
#		Types.AAMode.TEXTURE_FILL: _aa_mode.selected = AA_TEXTURE_FILL_INDEX
#
#	_set_languages(locale)
#	_set_rounding()
#
#	_pressure_sensitivity.value = pressure_sensitivity
#	_brush_size.value = brush_size
#	_brush_color.color = brush_color
#	_canvas_color.color = canvas_color
#	_project_dir.text = project_dir
#	_foreground_fps.value = foreground_fps
#	_background_fps.value = background_fps
#
#func _set_rounding():
#	_brush_rounding_options.selected = Settings.get_value(Settings.RENDERING_BRUSH_ROUNDING, Config.DEFAULT_BRUSH_ROUNDING)
#
## -------------------------------------------------------------------------------------------------
#func _set_languages(current_locale: String) -> void:
#	# Technically, Settings.language_names is useless from here on out, but I figure it's probably gonna come in handy in the future
#	var sorted_languages := Array(Settings.language_names)
#	var unsorted_languages := sorted_languages.duplicate()
#	# English appears at the top, so it mustn't be sorted alphabetically with the rest
#	sorted_languages.erase("English")
#	sorted_languages.sort()
#
#	# Add English before the rest + a separator so that it doesn't look weird for the alphabetical order to start after it
#	_language_options.add_item("English", unsorted_languages.find("English"))
#	_language_options.add_separator()
#	for lang in sorted_languages:
#		var id := unsorted_languages.find(lang)
#		_language_options.add_item(lang, id)
#
#	# Set selected
#	var id := Array(Settings.locales).find(current_locale)
#	_language_options.selected = _language_options.get_item_index(id)
#
## -------------------------------------------------------------------------------------------------
#func _on_DefaultBrushSize_value_changed(value: int) -> void:
#	Settings.set_value(Settings.GENERAL_DEFAULT_BRUSH_SIZE, int(value))
#
## -------------------------------------------------------------------------------------------------
#func _on_DefaultBrushColor_color_changed(color: Color) -> void:
#	Settings.set_value(Settings.GENERAL_DEFAULT_BRUSH_COLOR, color)
#
## -------------------------------------------------------------------------------------------------
#func _on_DefaultCanvasColor_color_changed(color: Color) -> void:
#	Settings.set_value(Settings.GENERAL_DEFAULT_CANVAS_COLOR, color)
#
## -------------------------------------------------------------------------------------------------
#func _on_PressureSensitivity_value_changed(value: float):
#	Settings.set_value(Settings.GENERAL_PRESSURE_SENSITIVITY, value)
#
## -------------------------------------------------------------------------------------------------
#func _on_DefaultSaveDir_text_changed(text: String) -> void:
#	text = text.replace("\\", "/")
#
#	var dir = Directory.new()
#	if dir.dir_exists(text):
#		Settings.set_value(Settings.GENERAL_DEFAULT_PROJECT_DIR, text)
#
## -------------------------------------------------------------------------------------------------
#func _on_Target_Fps_Foreground_changed(value: int) -> void:
#	Settings.set_value(Settings.RENDERING_FOREGROUND_FPS, value)
#
#	# Settings FPS so user instantly Sees fps Change else fps only changes after unfocusing
#	Engine.target_fps = value
#
## -------------------------------------------------------------------------------------------------
#func _on_Target_Fps_Background_changed(value: int) -> void:
#	# Background Fps need to be a minimum of 5 so you can smoothly reopen the window
#	Settings.set_value(Settings.RENDERING_BACKGROUND_FPS, value)
#
## -------------------------------------------------------------------------------------------------
#func _on_Theme_item_selected(index: int):
#	var theme: int
#	match index:
#		THEME_DARK_INDEX: theme = Types.UITheme.DARK
#		THEME_LIGHT_INDEX: theme = Types.UITheme.LIGHT
#
#	Settings.set_value(Settings.APPEARANCE_THEME, theme)
#	_appearence_restart_label.show()
#
## -------------------------------------------------------------------------------------------------
#func _on_AntiAliasing_item_selected(index: int):
#	var aa_mode: int
#	match index:
#		AA_NONE_INDEX: aa_mode = Types.AAMode.NONE
#		AA_OPENGL_HINT_INDEX: aa_mode = Types.AAMode.OPENGL_HINT
#		AA_TEXTURE_FILL_INDEX: aa_mode = Types.AAMode.TEXTURE_FILL
#
#	Settings.set_value(Settings.RENDERING_AA_MODE, aa_mode)
#	_rendering_restart_label.show()
#
## -------------------------------------------------------------------------------------------------
#func _on_Brush_rounding_item_selected(index: int):
#	match index:
#		0:
#			Settings.set_value(Settings.RENDERING_BRUSH_ROUNDING, Types.BrushRoundingType.FLAT)
#		1:
#			Settings.set_value(Settings.RENDERING_BRUSH_ROUNDING, Types.BrushRoundingType.ROUNDED)
#
#	# The Changes do work even without restarting but if the user doesn't restart old strokes remain
#	# the same (Don't wanna implement saving of the cap roundings per line since that would break file
#	# Compatibility)
#	_general_restart_label.show()
#
## -------------------------------------------------------------------------------------------------
#func _on_OptionButton_item_selected(idx: int):
#	var id := _language_options.get_item_id(idx)
#	var locale: String = Settings.locales[id]
#
#	Settings.set_value(Settings.GENERAL_LANGUAGE, locale)
#	TranslationServer.set_locale(locale)
#	_general_restart_label.show()
