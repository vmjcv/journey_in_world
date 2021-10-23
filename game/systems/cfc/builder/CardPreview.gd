extends Panel
# 视口内应该包含三种显示内容，分别为卡牌正面，卡牌背面，卡牌在游戏内的预览显示
# 可选是否显示


onready var front_node = $"VBoxContainer/Front"
onready var back_node = $"VBoxContainer/Back"
onready var ingame_node = $"VBoxContainer/InGame"

onready var option_button = $VBoxContainer/HBoxContainer/OptionButton

const _INFO_PANEL_SCENE_FILE = CFConst.PATH_CORE\
		+ "CardViewer/CVInfoPanel.tscn"
const _INFO_PANEL_SCENE = preload(_INFO_PANEL_SCENE_FILE)
export var info_panel_scene = _INFO_PANEL_SCENE

const _GRID_CARD_OBJECT_SCENE_FILE = "res://systems/cfc/builder/GridCardObject.tscn"
const _GRID_CARD_OBJECT_SCENE = preload(_GRID_CARD_OBJECT_SCENE_FILE)
export var grid_card_object_scene = _GRID_CARD_OBJECT_SCENE

var grid_card_object: CVGridCardObject

# Called when the node enters the scene tree for the first time.
func _ready():
	CardProjectManager.connect("change_metadata", self, "update_ui_from_data")
	pass # Replace with function body.

func remove_all_preview_tscn():
	Utils.remove_all_child(front_node)
	Utils.remove_all_child(back_node)
	Utils.remove_all_child(ingame_node)


func add_front_tscn(project):
	var definition_dict = project.meta_data.definition_dict
	var script_dict = project.meta_data.script_dict
	var card_name = project.meta_data.card_name
	if not project.meta_data.loaded:
		return 
	
	grid_card_object = grid_card_object_scene.instance()
	front_node.add_child(grid_card_object)
	# warning-ignore:return_value_discarded

	var template = load(CFConst.PATH_CARDS
			+ definition_dict[CardConfig.SCENE_PROPERTY] + ".tscn")
	var card = template.instance()
	card.canonical_name = card_name
	card.properties = Utils.transform_evalstring(definition_dict)
	card.scripts = Utils.transform_evalstring(script_dict)
	card.state = card.CardState.VIEWPORT_FOCUS
	grid_card_object.setup(card)
	card.state = card.CardState.PREVIEW
	
	grid_card_object.preview_popup.properties = Utils.transform_evalstring(definition_dict)
	grid_card_object.preview_popup.scripts = Utils.transform_evalstring(script_dict)
	grid_card_object.preview_popup.focus_info.info_panel_scene = info_panel_scene
	grid_card_object.preview_popup.focus_info.setup()
	

func add_back_tscn(project):
	pass

func add_in_game_tscn(project):
	pass

func update_card_ui(index=0):
	update_preview_ui(CardProjectManager.get_active_project())

func update_preview_ui(project):
	remove_all_preview_tscn()
	match option_button.selected:
		0:
			add_front_tscn(project)
		1:
			add_back_tscn(project)
		2:
			add_in_game_tscn(project)

func update_ui_from_data(project=CardProjectManager.get_active_project()):
	update_preview_ui(project)

