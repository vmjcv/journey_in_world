extends MeshInstance

var stencil_color = Color.white

func update_material():
	material_override.set_shader_param("stencil_color",stencil_color)
