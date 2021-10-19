extends HBoxContainer

var index: String

onready var KeyNameField: LineEdit = $KeyName
onready var ValueField: LineEdit = $Value
onready var TypeSelectionBtn: OptionButton = $TypeSelection
onready var ValueSelectionBtn: OptionButton = $ValueSelection
onready var RemoveBtn: Button = $Remove


var UseSelection = false
onready var dirty setget ,get_dirty


func setup(key="",value="",use_selection=false,can_remove=true,can_change_name=true,selection_list=[]):
	UseSelection = use_selection
	var showlist
	var hidelist 
	if UseSelection:
		# 使用选择模式
		hidelist = Utils.get_nodes_in_group(self,"Value")
		showlist = Utils.get_nodes_in_group(self,"ValueSelection")
	else:
		# 未使用选择模式
		showlist = Utils.get_nodes_in_group(self,"Value")
		hidelist = Utils.get_nodes_in_group(self,"ValueSelection")
	for node in hidelist:
		node.visible = false
	for node in showlist:
		node.visible = true
		
	RemoveBtn.visible = can_remove
	
	KeyNameField.editable = can_change_name
	
	KeyNameField.text = key
	KeyNameField.init_key = key
	
	if UseSelection:
		for one_value in selection_list:
			ValueSelectionBtn.add_item(one_value)
			if one_value == value:
				var idx = ValueSelectionBtn.get_item_count()
				ValueSelectionBtn.select(idx)
				ValueSelectionBtn.init_index = idx
	else:
		ValueField.text = value
		ValueField.init_text = value
	self.name = key
	
	
func get_dirty():
	return true
#	return ((not UseSelection) && KeyNameField.dirty &&  ValueField.dirty && TypeSelectionBtn.dirty)||(UseSelection && KeyNameField.dirty && ValueSelectionBtn.dirty)
