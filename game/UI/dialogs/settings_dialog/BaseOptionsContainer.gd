extends HBoxContainer
class_name BaseOptionsContainer
onready var _options: OptionButton = $ggsOptionList

var _options_map = {
}

func _ready():
	_update_options()
	var current = ggsManager.settings_data[str(get_node("ggsOptionList").setting_index)]["current"]
	_options.selected = current["value"]

func _update_options():
	if _options:
		var cur_selected = _options.selected
		_options.clear()
		for i in _options_map:
			_options.add_item(tr(_options_map[i]), i)
		_options.selected = cur_selected

func _notification(what):
	match what:
		NOTIFICATION_TRANSLATION_CHANGED:
			_update_options()
