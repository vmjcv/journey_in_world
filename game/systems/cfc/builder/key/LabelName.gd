extends LineEdit

var init_name setget set_init_name
var dirty setget ,get_dirty

func _ready():
	connect("text_entered",self,"_on_text_entered")

func get_dirty():
	return init_name != text
	
func set_init_name(_name):
	init_name = _name
	text = _name


func _on_text_entered(new_text):
#	if new_text != init_name:
	CardProjectManager.emit_signal("change_card_info_ui")
