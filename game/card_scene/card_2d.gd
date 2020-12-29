extends Sprite

var card_obj = preload("res://card_scene/card_template.tscn")

export var viewport_2d_size = Vector2(470,740) # 因为3d卡牌算上厚度在部分角度会超过尺寸
export var viewport_3d_size = Vector2(450,720)

func _ready():
	var card_obj1 = card_obj.instance()
	card_obj1.card_face_type = 1
	card_obj1.card_center_type = 1
	card_obj1.card_back_type = 1
	$"Viewport".size = viewport_2d_size
	$"Viewport".add_child(card_obj1)
	card_obj1.viewport_size = viewport_3d_size
	texture = $Viewport.get_texture()
