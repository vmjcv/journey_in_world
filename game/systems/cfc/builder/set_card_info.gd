extends VBoxContainer
# 卡牌类必定含有的基础数据，选择后再额外添加其他信息
var base_type = ["Type","Name","Abilities"]
var use_selection = {
	"Type":Types.card_type,
}
onready var ui_add_key_tscn = preload("res://systems/cfc/builder/key/uiAddKey.tscn")
onready var ui_key_tscn = preload("res://systems/cfc/builder/key/uiKey.tscn")
# Called when the node enters the scene tree for the first time.
var group_name = "info_key_node"
var add_node

func _ready():
	clean_all()
	add_base_attr()
	pass # Replace with function body.

func clean_all():
	Utils.remove_all_child(self)
	add_node = ui_add_key_tscn.instance()
	add_child(add_node)
	
func add_base_attr():
	# 增加默认属性，类型，名字，介绍
	for type in base_type:
		if use_selection.has(type):
			add_one_key(type,"",true,false,false,use_selection[type])
		else:
			add_one_key(type,"",false,false,false,[])

		
func add_one_key(key="",value="",use_selection=false,can_remove=true,can_change_name=true,selection_list=[]):
	var obj = ui_key_tscn.instance()
	add_child(obj)
	obj.setup(key,value,use_selection,can_remove,can_change_name,selection_list)
	obj.add_to_group(group_name)
	add_node.raise()
	
func get_value_from_node(attr_name):
	var node_obj = get_node_or_null(attr_name)
	var key_str = node_obj.KeyNameField.text
	var value_str = node_obj.ValueField.text
	var value = node_obj.ValueField.convert_value(value_str)
	return value

func get_all_attr_name():
	var all_attr = []
	for node in get_children():
		if node.is_in_group(group_name):
			all_attr.append(node.name)
	return all_attr

func get_all_attr_dict():
	var attr_dict = {}
	for attr_name in get_all_attr_name():
		attr_dict[attr_name] = get_value_from_node(attr_name)
	return attr_dict
