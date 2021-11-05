extends Node2D

const num_rows = 19 # 1行有几个格子,限定为奇数
const num_columns0 = 10 # 第一列有几个格子
const num_columns1 = 9 # 第二列有几个格子
const grid_outer_radius = 30
const HexRegionScene := preload("res://systems/cfc/battle_map/hex_region.tscn")

var hex_region_array : Array = []
var hex_region_dict : Dictionary = {}

func _ready():
	var count = 0
	for i in range(1, num_rows+1):
		var num_columns = [num_columns0,num_columns1][(i-1)%2]
		for j in range(1,num_columns+1):
			var map_region  = HexRegionScene.instance()
			add_child(map_region)
			map_region.outer_radius = grid_outer_radius
			map_region.set_column_row(i, j)
			map_region.index = count
			hex_region_array.append(map_region)
			hex_region_dict["c%d"%i+"r%d"%j] = map_region
			count = count + 1
	var center_x = int(floor((num_rows-1)/2+1))
	var center_y = int(floor(([num_columns0,num_columns1][(center_x-1)%2]-1)/2+1))

	var center_region = hex_region_dict["c%d"%center_x+"r%d"%center_y]	
	position = Vector2(-center_region.x,-center_region.y)


