extends Spatial


var card_camera_layer = 1<<2 setget set_card_camera_layer
var stencil_camera_layer = 1<<4 setget set_stencil_camera_layer

var stencil_color = Color.white setget set_stencil_color

func _ready():
	pass # Replace with function body.

func set_stencil_color(color):
	stencil_color = color
	$"卡内模型".material_override.set_shader_param("stencil_color",stencil_color)

func set_card_camera_layer(layer):
	card_camera_layer = layer
	$"Viewport/Camera2".cull_mask = card_camera_layer
	$"显示视口/Camera".cull_mask = stencil_camera_layer
	var all_nodes = []
	get_all_children($"Viewport",all_nodes)
	change_nodes_layer(all_nodes,card_camera_layer)
	
func set_stencil_camera_layer(layer):
	stencil_camera_layer = layer
	pass

func get_all_children(node,all_nodes=[]):
	for N in node.get_children():
		if N.get_child_count() > 0:
			get_all_children(N,all_nodes)
		else:
			all_nodes.append(N)

func change_nodes_layer(all_nodes,camera_layer):
	for n in all_nodes:
		if n is VisualInstance:
			n.layers = camera_layer
		if n is Camera:
			n.cull_mask = camera_layer
	
