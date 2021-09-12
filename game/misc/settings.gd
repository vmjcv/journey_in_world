extends Node

const DEFAULT_SECTION 					:= "settings"
const APPEARANCE_THEME 					:= "appearance_theme"
const RENDERING_FOREGROUND_FPS			:= "rendering_foreground_fps"
const RENDERING_BACKGROUND_FPS			:= "rendering_background_fps"

const GAME_SPEED						:= "game_speed"
const BATTLE_PREVIEW					:= "battle_preview"

const USE_2D							:= "use_2d"
const CAMERA_SHAKE						:= "camera_shake"
const COLOR_BLINDNESS_MODE				:= "color_blindness_mode"
const USER_INTERFACE_SIZE				:= "user_interface_size"
const HIDE_PLAYER_NAME					:= "hide_player_name"
const GAME_LANGUAGE						:= "game_language"
const INPUT_MAP							:= "input_map"
const IMAGE_QUALITY						:= "image_quality"
const RESOLUTION						:= "resolution"
const DISPLAY_MODE						:= "display_mode"
const AUDIO_SFX							:= "audio_sfx"
const AUDIO_MUSIC						:= "audio_music"
const AUDIO_MASTER						:= "audio_master"
const FANCY_MOVEMENT					:= "fancy_movement"
const OVAL_HAND_SHAPE					:= "oval_hand_shape"
const CARD_PREVIEW						:= "card_preview"
const USE_DEBUG							:= "use_debug"

# -------------------------------------------------------------------------------------------------
var _config_file := ConfigFile.new()

# -------------------------------------------------------------------------------------------------
func _ready():
	_config_file = ConfigFile.new()
	_load_settings()


# -------------------------------------------------------------------------------------------------
func _load_settings() -> int:
	var err = _config_file.load(Config.CONFIG_PATH)
	if err == ERR_FILE_NOT_FOUND:
		pass
	elif err != OK:
		printerr("Failed to load settings file")

	return err

# -------------------------------------------------------------------------------------------------
func _save_settings() -> int:
	var err = _config_file.save(Config.CONFIG_PATH)
	if err == ERR_FILE_NOT_FOUND:
		pass
	elif err != OK:
		printerr("Failed to load settings file")

	return err

# -------------------------------------------------------------------------------------------------
func get_value(key: String, default_value = null):
	return _config_file.get_value(DEFAULT_SECTION, key, default_value)

# -------------------------------------------------------------------------------------------------
func set_value(key: String, value = null):
	_config_file.set_value(DEFAULT_SECTION, key, value)
	_save_settings()
