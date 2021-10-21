extends BaseInput

enum Type {_bool, _float, _String}
onready var Root: HBoxContainer = get_parent()
var init_text
var dirty setget ,get_dirty




func get_dirty():
	return init_text!=text
