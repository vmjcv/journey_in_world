extends Spatial

var card_root_layer = 1
var card_face_camera_layer = 1<<2
var card_center_camera_layer = 1<<3
var card_back_camera_layer = 1<<4


func _ready():
	_init_signal()
	_init_ui()

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
	$"卡牌/卡面/卡面模型".stencil_color = stencil_color
	$"卡牌/卡面/卡面模型".update_child_material()

	$"卡牌/卡内/卡内模型".stencil_color = stencil_color
	$"卡牌/卡内/卡内模型".update_material()

func _init_camera():
	$Camera.cull_mask = card_root_layer
	$"卡牌/卡面".camera_layer = card_face_camera_layer
	$"卡牌/卡内".camera_layer = card_center_camera_layer
	$"卡牌/卡背".camera_layer = card_back_camera_layer
	




