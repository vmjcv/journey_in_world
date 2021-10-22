extends Reference
class_name CardProjectMetadata

var card_name
const CARD_NAME := "card_name"
var definition_dict = {}
var script_dict = {}

func _init(card_data={}):
	definition_dict = card_data.get("definition",{})
	script_dict = card_data.get("script",{})
	card_name = card_data.get("card_name","")

func clear():
	card_name = ""

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
