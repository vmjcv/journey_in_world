extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	$"三维卡/卡片ui/角色场景".mesh.surface_get_material(0).next_pass.set_shader_param("stencil_color",$"Viewport/Control/ViewportContainer/Viewport/主体画面".color)
	$"三维卡/卡牌模型".material_override.set_shader_param("stencil_color",$"Viewport/Control/ViewportContainer/Viewport/主体画面".color)
