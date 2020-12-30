extends Spatial

var card_root_layer = 1<<0
var card_face_camera_layer = 1<<1
var card_center_camera_layer = 1<<2
var card_back_camera_layer = 1<<3
var card_stencil_camera_layer = 1<<4

export var card_face_type = 1
export var card_center_type = 1
export var card_back_type = 1

var viewport_size setget set_viewport_size

var cost = 1 setget set_cost # 费用 
var card_name = "精卫鸟" setget set_card_name # 卡牌名字
var attack = 1  setget set_attack# 攻击力
var special = 1  setget set_special# 特殊效果数值
var blood = 1  setget set_blood# 血量
var shield = 1  setget set_shield# 盾量
var introduction = "追击" setget set_introduction# 卡牌介绍
var sect = "截"  setget set_sect# 教派
var rarity = 1 setget set_rarity # 稀有度
var race = "妖"  setget set_race# 种族

func set_cost(value):
	cost = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.cost = cost

func set_card_name(value):
	card_name = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.card_name = card_name

func set_attack(value):
	attack = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.attack = attack

func set_special(value):
	special = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.special = special

func set_blood(value):
	blood = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.blood = blood

func set_shield(value):
	shield = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.shield = shield

func set_introduction(value):
	introduction = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.introduction = introduction

func set_sect(value):
	sect = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.sect = sect

func set_rarity(value):
	rarity = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.rarity = rarity

func set_race(value):
	race = value
	var card_2d_ui = $"2d卡ui/Control"
	card_2d_ui.race = race

func _ready():
	_init_card_3d()
	_init_signal()
	_init_ui()

func _init_card_3d():
	var face_scene = load("res://card_scene/res/card_face/%d/scene.glb"%card_face_type)
	var face_scene1 = face_scene.instance()
	var face_scene2 = face_scene.instance()
	$"卡牌/卡面/卡面模型".add_child(face_scene1)
	$"卡牌/卡面/Viewport/Spatial".add_child(face_scene2)

	
	var center_scene = load("res://card_scene/res/card_center/%d/scene.glb"%card_center_type)
	var center_scene1 = center_scene.instance()
	$"卡牌/卡内/Viewport/Spatial".add_child(center_scene1)
	
	var back_scene = load("res://card_scene/res/card_back/%d/scene.glb"%card_back_type)
	var back_scene1 = back_scene.instance()
	$"卡牌/卡背/Spatial".add_child(back_scene1)
	
	
	
func _init_signal():
#	get_tree().get_root().connect("size_changed", self, "change_child_viewport_size")
	pass

func set_viewport_size(size):
	viewport_size = size
	$"卡牌/卡面/显示视口".size = viewport_size
	$"卡牌/卡面/Viewport".size = viewport_size
	$"卡牌/卡内/显示视口".size = viewport_size
	$"卡牌/卡内/Viewport".size = viewport_size


#func change_child_viewport_size():
#	var root_viewport_size = get_tree().get_root().size


func _init_ui():
	_init_stencil_color()
	_init_camera()

func _init_stencil_color():
	var stencil_color = $"2d卡ui/Control/ViewportContainer/Viewport/主体画面".color
	$"卡牌/卡面".stencil_color = stencil_color
	$"卡牌/卡内".stencil_color = stencil_color
	$"卡牌/卡背".stencil_color = stencil_color

func _init_camera():
	$Camera.cull_mask = card_root_layer+card_back_camera_layer
	$"卡牌/3d遮挡".layers = card_stencil_camera_layer
	$"卡牌/卡面".card_camera_layer = card_face_camera_layer
	$"卡牌/卡面".stencil_camera_layer = card_stencil_camera_layer
	$"卡牌/卡内".card_camera_layer = card_center_camera_layer
	$"卡牌/卡内".stencil_camera_layer = card_stencil_camera_layer
	$"卡牌/卡背".card_camera_layer = card_back_camera_layer
	$"卡牌/卡背".stencil_camera_layer = card_stencil_camera_layer
	




