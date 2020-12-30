extends Control

var cost = 1 setget set_cost # 费用 
var card_name = "精卫鸟" setget set_card_name # 卡牌名字
var attack = 1  setget set_attack# 攻击力
var special = 1  setget set_special# 特殊效果数值
var blood = 1  setget set_blood# 血量
var shield = 1  setget set_shield# 盾量
var introduction = "追击" setget set_introduction# 卡牌介绍
var sect = "截"  setget set_sect# 教派
var rarity = 1 setget set_rarity # 稀有度
var race = "妖"  setget set_race# 种族

func set_cost(value):
	cost = value
	$"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer/费用".text = str(cost)

func set_card_name(value):
	card_name = value
	$"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer2/名字".text = card_name

func set_attack(value):
	attack = value
	$"ViewportContainer2/Viewport/VBoxContainer/VBoxContainer/HBoxContainer3/攻击".text = str(attack)

func set_special(value):
	special = value
	$"ViewportContainer2/Viewport/VBoxContainer/VBoxContainer/HBoxContainer3/特殊".text = str(special)

func set_blood(value):
	blood = value
	$"ViewportContainer2/Viewport/VBoxContainer/VBoxContainer/HBoxContainer3/血量".text = str(blood)

func set_shield(value):
	shield = value
	$"ViewportContainer2/Viewport/VBoxContainer/VBoxContainer/HBoxContainer4/盾量".text = str(shield)

func set_sect(value):
	introduction = value
	$"ViewportContainer2/Viewport/VBoxContainer/VBoxContainer2/卡牌介绍".text = introduction

func set_introduction(value):
	sect = value
	$"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer3/势力".text = sect

func set_rarity(value):
	rarity = value
	$"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer3/稀有度".text = str(rarity)

func set_race(value):
	race = value
	$"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer3/种族".text = race





func _ready():
	var cur_rect_size = $"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer2/MarginContainer/主体画面定位容器".rect_size
	var cur_rect_global_position = $"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer2/MarginContainer/主体画面定位容器".rect_global_position
	$"ViewportContainer/Viewport/主体画面".rect_size = cur_rect_size
	$"ViewportContainer/Viewport/主体画面".rect_global_position = cur_rect_global_position
