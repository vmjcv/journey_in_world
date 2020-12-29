extends Spatial


var all_nodes = []

export var camera_layer = 8
var stencil_color = Color.white

func update_child_material():
	get_all_nodes(self)
	change_child_camera_layer()

func get_all_nodes(node):
	for N in node.get_children():
		if N.get_child_count() > 0:
			get_all_nodes(N)
		else:
			all_nodes.append(N)

func change_child_camera_layer():
	for n in all_nodes:
		if n is VisualInstance:
			n.material_override = ShaderMaterial.new()
			n.material_override.resource_local_to_scene = true
			n.material_override.shader = preload("res://test/card_face.shader")
			n.material_override.set_shader_param("stencil",$"../显示视口".get_texture())
			n.material_override.set_shader_param("center_scene",$"../Viewport".get_texture())
			n.material_override.set_shader_param("stencil_color",stencil_color)
