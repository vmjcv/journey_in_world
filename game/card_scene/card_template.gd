extends Spatial

var card_root_layer = 1<<0
var card_face_camera_layer = 1<<1
var card_center_camera_layer = 1<<2
var card_back_camera_layer = 1<<3
var card_stencil_camera_layer = 1<<4

export var card_face_type = 1
export var card_center_type = 1
export var card_back_type = 1

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
	# 因为暂时没有对于模型做标准化处理，所以在这边调整位置，需要注意准流程是对于模型做标准化处理，而不是在代码里面设置缩放
	face_scene1.scale = Vector3(3.5,3,3.7)
	face_scene2.scale = Vector3(3.5,3,3.7)

	
	var center_scene = load("res://card_scene/res/card_center/%d/scene.glb"%card_center_type)
	var center_scene1 = center_scene.instance()
	$"卡牌/卡内/Viewport/Spatial".add_child(center_scene1)
	# 因为暂时没有对于模型做标准化处理，所以在这边调整位置，需要注意准流程是对于模型做标准化处理，而不是在代码里面设置缩放
	center_scene1.scale = Vector3(0.1,0.1,0.1)
	center_scene1.rotation_degrees.x = -90
	
	var back_scene = load("res://card_scene/res/card_back/%d/scene.glb"%card_back_type)
	var back_scene1 = back_scene.instance()
	$"卡牌/卡背/Spatial".add_child(back_scene1)
	# 因为暂时没有对于模型做标准化处理，所以在这边调整位置，需要注意准流程是对于模型做标准化处理，而不是在代码里面设置缩放
	back_scene1.scale = Vector3(1.35,1.3,1.45)
	
	
	
func _init_signal():
	get_tree().get_root().connect("size_changed", self, "change_child_viewport_size")

func change_child_viewport_size():
	var root_viewport_size = get_tree().get_root().size
	$"卡牌/卡面/显示视口".size = root_viewport_size
	$"卡牌/卡面/Viewport".size = root_viewport_size
	$"卡牌/卡内/显示视口".size = root_viewport_size
	$"卡牌/卡内/Viewport".size = root_viewport_size

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
	




