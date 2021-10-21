extends HBoxContainer


onready var EnvSelection = $EnvSelection
onready var ScriptName = $VBoxContainer/HBoxContainer/ScriptName
onready var SubjectSelection = $VBoxContainer/HBoxContainer/SubjectSelection
onready var AddButton = $VBoxContainer/HBoxContainer/uiAddKey
onready var RemoveButton = $VBoxContainer/HBoxContainer/Remove
onready var ScriptContainer = $VBoxContainer

onready var dirty setget ,get_dirty


const _ARGS_SCENE_FILE = "res://systems/cfc/builder/key/uiArgs.tscn"
const _ARGS_SCENE = preload(_ARGS_SCENE_FILE)

const args_scene_group = "args"

func get_dirty():
	for obj in [EnvSelection,ScriptName,SubjectSelection,AddButton,RemoveButton]:
		if obj.dirty:
			return true
	for obj in Utils.get_nodes_in_group(ScriptContainer,args_scene_group):
		if obj.dirty:
			return true
	return false

func setup(env_name,script_name,subject_name,data_map={}):
	EnvSelection.selection_array = ["board","hand"]
	EnvSelection.init_name = env_name
	
	ScriptName.init_name = script_name
	
	SubjectSelection.selection_array = [SP.KEY_SUBJECT_V_PREVIOUS,SP.KEY_SUBJECT_V_TARGET,
	SP.KEY_SUBJECT_V_BOARDSEEK,SP.KEY_SUBJECT_V_TUTOR,SP.KEY_SUBJECT_V_INDEX,SP.KEY_SUBJECT_V_TRIGGER,SP.KEY_SUBJECT_V_SELF]
	SubjectSelection.init_name = subject_name
	
	var value 
	var value_type
	for key in data_map:
		value = data_map[key]
		match value:
			TYPE_BOOL:
				value_type = "Boolean"
			TYPE_REAL:
				value_type = "Number"
			TYPE_STRING:
				value_type = "String"
		value = str(value)
		add_one_arg(key,value,value_type)
	
func _on_Remove_pressed():
	queue_free()

func _on_uiAddKey_pressed():
	# 增加一个arg
	add_one_arg()

func add_one_arg(arg_name="",value_name="",value_type_name=""):
	var arg_node = _ARGS_SCENE.instance()
	ScriptContainer.add_child(arg_node)
	arg_node.add_to_group(args_scene_group)
	arg_node.setup(arg_name,value_name,value_type_name)
	
func get_data():
	var env = EnvSelection.get_item_text(EnvSelection.selected)
	var script_name = ScriptName.text
	var subject_name = SubjectSelection.get_item_text(SubjectSelection.selected)
	var args = {}
	for obj in Utils.get_nodes_in_group(ScriptContainer,args_scene_group):
		args = Utils.merge_dict(args,obj.get_data())
	return {"env":env,"script_name":script_name,"subject_name":subject_name,"args":args}
