extends Spatial


var all_nodes = []

export var camera_layer = 8

func _ready():
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
			var stencil_viewport = ViewportTexture.new()
			stencil_viewport.viewport_path = "卡牌/卡面/显示视口"
			n.material_override.set_shader_param("stencil",stencil_viewport)
			

			var obj_viewport = ViewportTexture.new()
			obj_viewport.viewport_path = "卡牌/卡面/Viewport"
			n.material_override.set_shader_param("center_scene",obj_viewport)
			
			n.material_override.set_shader_param("stencil_color",Color.white)
			pass
