extends TabContainer


var _tab_audio: Control
var _tab_grahics: Control
var _tab_game_play: Control
var _tab_extra_features: Control
var _tab_other: Control

onready var is_ready = true

func _ready():
	# 如果使用onready变量的话需要在ready调用会判断为空
	_tab_audio = $Audio
	_tab_grahics = $Graphics
	_tab_game_play = $GamePlay
	_tab_extra_features = $ExtraFeatures
	_tab_other = $Other
	_update_tab_name()


func _update_tab_name():
	_tab_audio.name = tr("AUDIO")
	_tab_grahics.name = tr("GRAPHICS")
	_tab_game_play.name = tr("GAME_PLAY")
	_tab_extra_features.name = tr("EXTRA_FEATURES")
	_tab_other.name = tr("OTHER")

func _notification(what):
	match what:
		NOTIFICATION_TRANSLATION_CHANGED:
			if is_ready:
				_update_tab_name()


