extends LineEdit

var init_name setget set_init_name
var dirty setget ,get_dirty

func get_dirty():
	return init_name != text
	
func set_init_name(_name):
	init_name = _name
	text = _name
