extends Sprite

var card_obj = preload("res://card_scene/card_template.tscn")

export var viewport_2d_size = Vector2(470,740) # 因为3d卡牌算上厚度在部分角度会超过尺寸
export var viewport_3d_size = Vector2(450,720)

export var cost = 1 # 费用
export var card_name = "精卫鸟" # 卡牌名字
export var attack = 1 # 攻击力
export var special = 1 # 特殊效果数值
export var blood = 1 # 血量
export var shield = 1 # 盾量
export var introduction = "追击" # 卡牌介绍
export var sect = "截" # 教派
export var rarity = 1 # 稀有度
export var race = "妖" # 种族

export var card_face_type = 1 # 卡面
export var card_center_type = 1 # 卡中
export var card_back_type = 1 # 卡背


func _ready():
	var card_obj1 = card_obj.instance()
	card_obj1.card_face_type = card_face_type
	card_obj1.card_center_type = card_center_type
	card_obj1.card_back_type = card_back_type
	card_obj1.cost = cost
	card_obj1.card_name = card_name
	card_obj1.attack = attack
	card_obj1.special = special
	card_obj1.blood = blood
	card_obj1.shield = shield
	card_obj1.introduction = introduction
	card_obj1.sect = sect
	card_obj1.rarity = rarity
	card_obj1.race = race
	$"Viewport".size = viewport_2d_size
	$"Viewport".add_child(card_obj1)
	card_obj1.viewport_size = viewport_3d_size
	texture = $Viewport.get_texture()
