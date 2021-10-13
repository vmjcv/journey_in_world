extends Panel
# 视口内应该包含三种显示内容，分别为卡牌正面，卡牌背面，卡牌在游戏内的预览显示
# 可选是否显示

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var front_node = $"VBoxContainer/Front"
onready var back_node = $"VBoxContainer/Back"
onready var ingame_node = $"VBoxContainer/InGame"

const _GRID_CARD_OBJECT_SCENE_FILE = CFConst.PATH_CORE\
		+ "CardViewer/CVGridCardObject.tscn"
const _GRID_CARD_OBJECT_SCENE = preload(_GRID_CARD_OBJECT_SCENE_FILE)
export var grid_card_object_scene = _GRID_CARD_OBJECT_SCENE

var grid_card_object: CVGridCardObject

# Called when the node enters the scene tree for the first time.
func _ready():
	var test_card = cfc.instance_card("Test Card 1")
	add_child(test_card)
	pass # Replace with function body.

func remove_all_preview_tscn():
	Utils.remove_all_child(front_node)
	Utils.remove_all_child(back_node)
	Utils.remove_all_child(ingame_node)

func _on_OptionButton_item_selected(index):
	remove_all_preview_tscn()
	match index:
		0:
			add_front_tscn()
		1:
			add_back_tscn()
		2:
			add_in_game_tscn()

func add_front_tscn():
	var active_project = CardProjectManager.get_active_project()
	if not active_project:
		return 
	var data = active_project.meta_data
	var card_name = data.card_name
	match data.card_type:
		"Rule":
			add_front_card(card_name)
	
func add_front_card(card_name):
	grid_card_object = grid_card_object_scene.instance()
	front_node.add_child(grid_card_object)
	# warning-ignore:return_value_discarded
	grid_card_object.setup(card_name)

	

func add_back_tscn():
	var active_project = CardProjectManager.get_active_project()
	if not active_project:
		return 

func add_in_game_tscn():
	var active_project = CardProjectManager.get_active_project()
	if not active_project:
		return 
