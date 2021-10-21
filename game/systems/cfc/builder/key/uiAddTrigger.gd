extends VBoxContainer



onready var TriggerName = $uiTriggerScript/TriggerName
onready var TriggerSelection = $uiTriggerScript/TriggerSelection
onready var ScriptNode = $uiKeyScript

onready var dirty setget ,get_dirty



func get_dirty():
	for obj in [TriggerName,TriggerSelection,ScriptNode]:
		if obj.dirty:
			return true
	return false

func setup(trigger_signal_name,trigger_name,env_name,script_name,subject_name,data_map={}):
	TriggerName.init_name = trigger_signal_name
	
	TriggerSelection.selection_array = ["self","another","any"]
	TriggerSelection.init_name = trigger_name
	
	ScriptNode.setup(env_name,script_name,subject_name,data_map)
	
	
func _on_Remove_pressed():
	queue_free()


func get_data():
	var script_dict = ScriptNode.get_data()
	var trigger_func_name = TriggerName.text
	var trigger_name = TriggerSelection.get_item_text(TriggerSelection.selected)
	var trigger_dict = {"func_name":trigger_func_name,"trigger_name":trigger_name}
	return Utils.merge_dict(trigger_dict,script_dict)
