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

onready var dirty setget ,get_dirty

func _on_MenuButton_pressed():
	_main_menu.popup()
	_main_menu.rect_global_position = $VBoxContainer/HBoxContainer.rect_global_position+Vector2(0,20)

# -------------------------------------------------------------------------------------------------
func _ready():
	_main_menu.connect("add_attr_ui", self, "_on_add_attr_ui")
	_main_menu.connect("add_script_ui", self, "_on_add_script_ui")
	_main_menu.connect("add_trigger_ui", self, "_on_add_trigger_ui")
	CardProjectManager.connect("change_active_project", self, "update_ui_from_data")
	init_ui()

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

func get_all_script_list():
	var script_list = []
	for _script_node in _container_script.get_children():
		var cur_dict = _script_node.get_data()
		script_list.append(cur_dict)
	return script_list
	
func get_all_trigger_list():
	var trigger_list = []
	for _trigger_node in _container_trigger.get_children():
		var cur_dict = _trigger_node.get_data()
		trigger_list.append(cur_dict)
	return trigger_list

func _process(delta):
	# 每帧刷新，其实可以更改的时候做刷新数据的操作，待定
	if get_dirty():
		if CardProjectManager.get_active_project().meta_data:
			CardProjectManager.get_active_project().meta_data.update_data_from_ui(self)
			CardProjectManager.get_active_project().dirty = true
	else:
		if CardProjectManager.get_active_project().meta_data:
			CardProjectManager.get_active_project().dirty = false


func get_dirty():
	var cur_list = []
	cur_list.append_array(_container_attr.get_children())
	cur_list.append_array(_container_script.get_children())
	cur_list.append_array(_container_trigger.get_children())
	var dir
	for node in cur_list:
		if node.dirty:
			return true
	return false


func init_ui():
	clean_all()
	add_base_attr()
	
func update_ui_from_data(project):
	if not project.meta_data:
		init_ui()
		return 
	var definition_data = project.meta_data.definition_dict
	var script_data = project.meta_data.script_dict
	var card_name = project.meta_data.card_name
	clean_all()
	
	add_attr_ui("Name",card_name,[],false)
	
	for key in definition_data:
		add_attr_ui(key,definition_data[key],use_selection.get(key,[]),not(key in base_type))
	
	var cur_script_data = script_data.get("manual",{})
	for key in cur_script_data:
		var cur_data = cur_script_data[key]
		for one_data in cur_data:
			var script_name = one_data["name"]
			var subject_name = one_data["subject"]
			var args_dict = {}
			args_dict = one_data.duplicate(true)
			args_dict.erase("name")
			args_dict.erase("subject")
			add_script_ui(key,script_name,subject_name,args_dict)
	
	var trigger_dict = script_data.duplicate(true)
	trigger_dict.erase("manual")
	
	for key in trigger_dict:
		var trigger_name = trigger_dict[key]["trigger"]
		trigger_dict[key].erase("trigger")
		for env_key in trigger_dict[key]:
			var cur_data = trigger_dict[key].get(env_key,[])
			for one_data in cur_data:
				var script_name = one_data["name"]
				var subject_name = one_data["subject"]
				var args_dict = {}
				args_dict = one_data.duplicate(true)
				args_dict.erase("name")
				args_dict.erase("subject")
				add_trigger_ui(key,trigger_name,env_key,script_name,subject_name,args_dict)
			
	

