extends OptionButton

var init_index = -1
var init_name setget set_init_name
var dirty setget ,get_dirty

var selection_array setget set_selection_array

func _ready():
	connect("item_selected",self,"_on_item_selected")

func get_dirty():
	return init_index != selected
	
func set_selection_array(_array):
	for label in _array:
		add_item(label)

func set_init_name(_name):
	for index in range(get_item_count()):
		if get_item_text(index) == _name:
			init_index = index
			selected = index
			return 
	init_index = -1

func _on_item_selected(index):
#	if init_index!=init_index:
	CardProjectManager.emit_signal("change_card_info_ui")
