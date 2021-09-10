class_name Config

const VERSION_MAJOR					:= 0
const VERSION_MINOR					:= 4
const VERSION_PATCH					:= 0
const VERSION_STATUS				:= "-dev"
const VERSION_STRING				:= "%d.%d.%d%s" % [VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH, VERSION_STATUS]
const CONFIG_PATH 					:= "user://settings.cfg"
const DEFAULT_FOREGROUND_FPS 		:= 144
const DEFAULT_BACKGROUND_FPS		:= 10
const HIDE_PLAYER_NAME				:= false
const GAME_LANGUAGE					:= null
const USE_2D						:= true
const CAMERA_SHAKE					:= true
const COLOR_BLINDNESS_MODE			:= Types.ColorBlindnessMode.DEFAULT
const USER_INTERFACE_SIZE			:= Types.UserInterfaceSize.DEFAULT
