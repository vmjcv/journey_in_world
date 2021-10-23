extends Reference
class_name CardProjectMetadata

var card_name
const CARD_NAME := "card_name"
var definition_dict = {}
var script_dict = {}
var loaded = false

func _init(card_data={}):
	definition_dict = card_data.get("definition",{})
	script_dict = card_data.get("script",{})
	card_name = card_data.get("card_name","")
	loaded = true
	if card_data.empty():
		loaded = false

func clear():
	card_name = ""
	loaded = false

func update_data_from_ui(card_info_ui):
	var attr_dict = card_info_ui.get_all_attr_dict()
	var script_list = card_info_ui.get_all_script_list()
	var trigger_list = card_info_ui.get_all_trigger_list()
	
	card_name = attr_dict["Name"]
	attr_dict.erase("Name")
	definition_dict = attr_dict
	script_dict = {}
	script_dict["manual"] = {}
	for info in script_list:
		var cur_dict = {"name":info["script_name"],"subject":info["subject_name"]}
		for arg_key in info["args"]:
			cur_dict[arg_key] = info["args"][arg_key]
		if not script_dict["manual"].has(info["env"]):
			script_dict["manual"][info["env"]] = []
		script_dict["manual"][info["env"]].append(cur_dict)
		
		
	for info in trigger_list:
		script_dict[info["func_name"]] = {}
		var cur_dict = {"name":info["script_name"],"subject":info["subject_name"]}
		for arg_key in info["args"]:
			cur_dict[arg_key] = info["args"][arg_key]
		if not script_dict[info["func_name"]].has(info["env"]):
			script_dict[info["func_name"]][info["env"]] = []
		script_dict[info["func_name"]][info["env"]].append(cur_dict)	
		script_dict[info["func_name"]]["trigger"] = info["trigger_name"]
	
	# 是否需要在这里更新全局信息，或者做个只有预览的信息，需要再次斟酌
	# 更新所有属性后再更新脚本信息
	loaded = true
	CardProjectManager.emit_signal("change_metadata")
