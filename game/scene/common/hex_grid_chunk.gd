extends Spatial
class_name HexGridChunk

var cells:Array

func _ready():
	pass

func update_mesh():
	# 更新块区内所有的模型内容
	pass

func add_cell(index,cell):
	cells[index] = cell
	add_child(cell)