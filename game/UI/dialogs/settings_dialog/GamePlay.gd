extends Control


onready var _shortcut_key_container_toggle_button: Button = $VBoxContainer/ShortcutKey/ToggleButton
onready var _shortcut_key_container_reset_button: Button = $VBoxContainer/ShortcutKey/ResetButton
onready var _shortcut_key_container: ScrollContainer = $VBoxContainer/ShortcutKeyContainer
onready var _shortcut_key_box_list: VBoxContainer = $VBoxContainer/ShortcutKeyContainer/ShortcutKeyBoxList
onready var _shortcut_key_pop_up: Popup = $Popup


var _action_bind:PackedScene = preload("res://UI/dialogs/settings_dialog/ActionNode.tscn")
var _control_bind:PackedScene = preload("res://UI/dialogs/settings_dialog/ControlNode.tscn")
var action_nodes = {}

export(int, 0, 99) var setting_index: int # 共用18的input_map,如果插件逻辑更改可能需要调整结构


var _action_map = {
	"Card1":"CARD1",
	"Card2":"CARD2",
	"Card3":"CARD3",
	"Card4":"CARD4",
	"Card5":"CARD5",
	"ToggleGameSpeed":"TOGGLE_GAME_SPEED",
	"UseCard":"USE_CARD",
	"CancelUseCard":"CANCEL_USE_CARD",
	"Setting":"SETTING",
	"Left":"LEFT",
	"Right":"RIGHT",
	"Up":"UP",
	"Down":"DOWN",
	"ShowCards":"SHOW_CARDS",
	"ShowDrawCards":"SHOW_DRAW_CARDS",
	"ShowDiscardCards":"SHOW_DISCARD_CARDS",
	"ShowShortcutKey":"SHOW_SHORTCUT_KEY",
	"ShowMap":"SHOW_MAP",
}
var _input_map
onready var is_ready = true
func _ready():
	_toggle_shortcut_key_container(false)
	_update_input_map() # 更新全部数据，这个数据包含了游戏默认设置中的数据信息
	_update_ui() # 更新栏位

func _update_input_map():
	# 加载项目默认配置+配置文件中的默认配置，会直接改变游戏内的当前状态
	InputMap.load_from_globals() # 加载全部的默认配置
	var current = ggsManager.settings_data[str(setting_index)]["current"]
	var input_map = current["value"]
	for action_name in input_map:
		InputMap.action_erase_events(action_name)
		for event in input_map[action_name]:
			InputMap.action_add_event(action_name, event)
	input_map = {}
	for action_name in Types.Actions:
		var action_list:Array = InputMap.get_action_list(action_name) #associated controlls to the action
		input_map[action_name] = action_list
	_input_map = input_map
	return input_map

func _save_input_map():
	# 加载项目默认配置+配置文件中的默认配置，会直接改变游戏内的当前状态
	var current_value = ggsManager.settings_data[str(setting_index)]["current"]
	current_value["value"] = _input_map
	ggsManager.save_settings_data()
	var script: Script = load(ggsManager.settings_data[str(setting_index)]["logic"])
	var script_instance = script.new()
	script_instance.main(current_value)

func _shortcut_key_container_toggle_button_toggled(button_pressed):
	_toggle_shortcut_key_container(button_pressed)

func _toggle_shortcut_key_container(pressed):
	_shortcut_key_container.visible = pressed
	_shortcut_key_container_toggle_button.text = "-" if pressed else "+"

func _shortcut_key_container_reset_button_toggled():
	_input_map = to_json({})
	_save_input_map()
	# 已经完成数据保存+游戏输入状态设置，但是ui还未变换更新
	_update_input_map() # 更新全部数据，这个数据包含了游戏默认设置中的数据信息
	_update_ui() # 更新栏位


func _update_ui():
	# 更新所有的默认值
	Utils.remove_all_child(_shortcut_key_box_list)
	action_nodes = {}
	for action_name in Types.Actions:
		var action_node:VBoxContainer = _action_bind.instance()
		_shortcut_key_box_list.add_child(action_node)
		action_nodes[action_name] = action_node #Save node for easier access
		var cur_name:Label = action_node.find_node("Name") #Name of actions
		var cur_add:Button = action_node.find_node("AddAction") #Used for adding new ControlBind
		cur_name.text = tr(_action_map[action_name])
		cur_add.connect("pressed", self, "add_control", [action_name])
		_update_control_list(action_name)

func add_control(action_name)->void:
	_shortcut_key_pop_up.popup_centered()
	yield(_shortcut_key_pop_up, "new_control")
	if _shortcut_key_pop_up.new_event == null:
		return
	var event:InputEvent = _shortcut_key_pop_up.new_event
	_input_map[action_name].push_back(event)
	_save_input_map()
	_update_control_list(action_name)


func _update_control_list(action_name):
	var action_control = action_nodes[action_name]
	var action_data = _input_map[action_name]
	Utils.remove_all_child_in_group(action_control,"input_event_node")
	# 增加节点表现
	for cur_input in action_data:
		var event_node = _control_bind.instance()
		action_control.add_child(event_node)
		var cur_name:Label = event_node.find_node("Name")
		var cur_remove:Button = event_node.find_node("RemoveAction")
		cur_name.text = tr(get_inpue_event_name(cur_input))
		cur_remove.connect("pressed", self, "remove_control", [[action_name, cur_input]])

func remove_control(Bind:Array)->void:
	var action_name:String = Bind[0]
	var cur_input:InputEvent = Bind[1]
	var index:int = _input_map[action_name].find(cur_input)
	_input_map[action_name].remove(index)
	_save_input_map()
	_update_control_list(action_name)

func get_inpue_event_name(event:InputEvent)->String:
	var text:String = ""
	if event is InputEventKey:
		text = tr("KEY_BOARD")+": " + event.as_text()
	elif event is InputEventJoypadButton:
		text = "Gamepad: "
		if Input.is_joy_known(event.device):
			text+= str(Input.get_joy_button_string(event.button_index))
		else:
			text += "Btn. " + str(event.button_index)
	elif event is InputEventJoypadMotion:
		text = "Gamepad: "
		var stick: = ''
		if Input.is_joy_known(event.device):
			stick = str(Input.get_joy_axis_string(event.axis))
			text+= stick + " "
		else:
			text += "Axis: " + str(event.axis) + " "

		if !stick.empty():	#known
			var value:int = round(event.axis_value)
			if stick.ends_with('X'):
				if value > 0:
					text += 'Rigt'
				else:
					text += 'Left'
			else:
				if value > 0:
					text += 'Down'
				else:
					text += 'Up'
		else:
			text += str(round(event.axis_value))
	return text


func _notification(what):
	match what:
		NOTIFICATION_TRANSLATION_CHANGED:
			if is_ready:
				_update_ui()
