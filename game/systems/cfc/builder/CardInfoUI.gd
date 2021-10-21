extends Panel

# 卡牌类必定含有的基础数据，选择后再额外添加其他信息
var base_type = ["Type","Name","Abilities"]
var use_selection = {
	"Type":Types.card_type,
}

onready var _main_menu = $MainMenu
onready var _container_attr = $VBoxContainer/VBoxContainer
onready var _container_script = $VBoxContainer/VBoxContainer2
onready var _container_trigger = $VBoxContainer/VBoxContainer3

const _ATTR_SCENE_FILE = "res://systems/cfc/builder/key/uiAddAttr.tscn"
const _ATTR_SCENE = preload(_ATTR_SCENE_FILE)

const _SCRIPT_SCENE_FILE = "res://systems/cfc/builder/key/uiAddScript.tscn"
const _SCRIPT_SCENE = preload(_SCRIPT_SCENE_FILE)

const _TRIGGER_SCENE_FILE = "res://systems/cfc/builder/key/uiAddTrigger.tscn"
const _TRIGGER_SCENE = preload(_TRIGGER_SCENE_FILE)

var group_attr_name = "info_attr"
var group_script_name = "info_script"
var group_signal_name = "info_signal"

func _on_MenuButton_pressed():
	_main_menu.popup()
	_main_menu.rect_global_position = $VBoxContainer/HBoxContainer.rect_global_position+Vector2(0,20)

# -------------------------------------------------------------------------------------------------
func _ready():
	_main_menu.connect("add_attr_ui", self, "_on_add_attr_ui")
	_main_menu.connect("add_script_ui", self, "_on_add_script_ui")
	_main_menu.connect("add_trigger_ui", self, "_on_add_trigger_ui")
	clean_all()
	add_base_attr()

func _on_add_attr_ui():
	add_attr_ui("","",[],true)
	pass
	
func _on_add_script_ui():
	add_script_ui("","","",{})
	pass
	
func _on_add_trigger_ui():
	add_trigger_ui("","","","","",{})
	pass
	
func add_attr_ui(attr_name,value,value_array=[],can_edit_attr_name=true):
	var obj = _ATTR_SCENE.instance()
	_container_attr.add_child(obj)
	obj.setup(attr_name,value,value_array,can_edit_attr_name)
	obj.add_to_group(group_attr_name)
	
func add_script_ui(env_name,script_name,subject_name,data_map={}):
	var obj = _SCRIPT_SCENE.instance()
	_container_script.add_child(obj)
	obj.setup(env_name,script_name,subject_name,data_map)
	obj.add_to_group(group_script_name)

func add_trigger_ui(trigger_signal_name,trigger_name,env_name,script_name,subject_name,data_map={}):
	var obj = _TRIGGER_SCENE.instance()
	_container_trigger.add_child(obj)
	obj.setup(trigger_signal_name,trigger_name,env_name,script_name,subject_name,data_map)
	obj.add_to_group(group_signal_name)
	
func clean_all():
	Utils.remove_all_child(_container_attr)
	Utils.remove_all_child(_container_script)
	Utils.remove_all_child(_container_trigger)
	
func add_base_attr():
	# 增加默认属性，类型，名字，介绍
	for type in base_type:
		add_attr_ui(type,"",use_selection.get(type,[]),false)

func get_all_attr_dict():
	var attr_dict = {}
	for _attr_node in _container_attr.get_children():
		var cur_dict = _attr_node.get_data()
		attr_dict = Utils.merge_dict(attr_dict,cur_dict)
	return attr_dict

func get_all_script_dict():
	var script_dict = {}
	for _script_node in _container_script.get_children():
		var cur_dict = _script_node.get_data()
		script_dict = Utils.merge_dict(script_dict,cur_dict)
	return script_dict
	
func get_all_trigger_dict():
	var trigger_dict = {}
	for _trigger_node in _container_trigger.get_children():
		var cur_dict = _trigger_node.get_data()
		trigger_dict = Utils.merge_dict(trigger_dict,cur_dict)
	return trigger_dict
	
