extends HBoxContainer



onready var AttrName = $AttrName
onready var ValueName = $ValueName
onready var ValueNameSelection = $ValueNameSelection
onready var ValueSelection = $ValueSelection

onready var RemoveButton = $Remove

onready var dirty setget ,get_dirty
var data setget ,get_data
var UseSelection = false

func get_dirty():
	var obj_list
	if UseSelection:
		obj_list = [AttrName,ValueSelection]
	else:
		obj_list = [AttrName,ValueName,ValueNameSelection]
	for obj in obj_list:
		if obj.dirty:
			return true
	return false

func setup(attr_name,value,value_array=[],can_edit_attr_name=true):
	if len(value_array)!=0:
		# 使用选择模式
		UseSelection = true
	else:
		UseSelection = false
		
	ValueNameSelection.visible = not UseSelection
	ValueName.visible = not UseSelection
	ValueSelection.visible = UseSelection
	
	AttrName.init_name = attr_name
	AttrName.editable = can_edit_attr_name
	
	RemoveButton.visible = can_edit_attr_name
	
	
	if UseSelection:
		ValueSelection.selection_array = value_array
		ValueSelection.init_name = value
	else:
		ValueNameSelection.selection_array = ["Boolean","Number","String"]
		var value_type
		match typeof(value):
			TYPE_BOOL:
				value_type = "Boolean"
			TYPE_REAL:
				value_type = "Number"
			TYPE_STRING:
				value_type = "String"
		
		value = str(value)
		ValueNameSelection.init_name = value_type
		ValueName.init_name = value

	
func _on_Remove_pressed():
	queue_free()

func get_data():
	if UseSelection:
		return {AttrName.text:ValueSelection.get_item_text(ValueSelection.selected)}
	else:
		return {AttrName.text:Utils.convert_value(ValueName.text,ValueNameSelection.selected)}
	return {}
