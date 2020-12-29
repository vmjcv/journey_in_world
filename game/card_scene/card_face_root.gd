extends Spatial


var card_camera_layer = 1<<1 setget set_card_camera_layer
var stencil_camera_layer = 1<<4 setget set_stencil_camera_layer

var stencil_color = Color.white setget set_stencil_color

var card_face_shader = preload("res://card_scene/card_face.shader")

func _ready():
	pass # Replace with function body.

func set_stencil_color(color):
	stencil_color = color
	var all_nodes = []
	get_all_children($"卡面模型",all_nodes)
	change_nodes_material(all_nodes,stencil_color)


func set_card_camera_layer(layer):
	card_camera_layer = layer
	$"Viewport/Camera2".cull_mask = card_camera_layer
	$"显示视口/Camera".cull_mask = stencil_camera_layer
	var all_nodes = []
	get_all_children($"Viewport",all_nodes)
	change_nodes_layer(all_nodes,card_camera_layer)
	
func set_stencil_camera_layer(layer):
	stencil_camera_layer = layer
#	var all_nodes = []
#	get_all_children($"卡面模型",all_nodes)
#	change_nodes_layer(all_nodes,stencil_camera_layer)
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
	
func change_nodes_material(all_nodes,color):
	for n in all_nodes:
		if n is VisualInstance:
			n.material_override = ShaderMaterial.new()
			n.material_override.resource_local_to_scene = true
			n.material_override.shader = card_face_shader
			n.material_override.set_shader_param("stencil",$"显示视口".get_texture())
			n.material_override.set_shader_param("center_scene",$"Viewport".get_texture())
			n.material_override.set_shader_param("stencil_color",color)
