extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"卡片ui/MeshInstance".get_surface_material(0).set_shader_param("stencil_color",$"Viewport/Control/ViewportContainer/Viewport/主体画面".color)
	$"CSGBox".material_override.next_pass.set_shader_param("stencil_color",$"Viewport/Control/ViewportContainer/Viewport/主体画面".color)
