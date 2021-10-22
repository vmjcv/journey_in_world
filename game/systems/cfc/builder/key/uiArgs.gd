extends HBoxContainer

onready var ArgName = $ArgName
onready var ArgValue = $ArgValue
onready var ArgTypeSelection = $ArgValueType
onready var RemoveButton = $Remove

onready var dirty setget ,get_dirty


func get_dirty():
	for obj in [ArgName,ArgValue,ArgTypeSelection]:
		if obj.dirty:
			return true

func setup(arg_name="",value_name="",value_type_name=""):
	ArgName.init_name = arg_name
	ArgValue.init_name = value_name
	
	ArgTypeSelection.selection_array = ["Boolean","Number","String","EvalString"]
	ArgTypeSelection.init_name = value_type_name
	
func _on_Remove_pressed():
	queue_free()

func get_data():
	return {ArgName.text:Utils.convert_value(ArgValue.text,ArgTypeSelection.selected)}
			
