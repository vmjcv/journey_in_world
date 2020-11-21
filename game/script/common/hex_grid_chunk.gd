extends Spatial
class_name HexGridChunk
var hex_metrics = HexStatic.HexMetrics.new()
var cells:Array

func _ready():
	cells = []
	cells.resize(hex_metrics.chunk_size_x*hex_metrics.chunk_size_z)

func refresh():
	# 更新块区内所有的模型内容
	for cell in cells:
		cell.update_mesh()


func add_cell(index,cell):
	cells[index] = cell
	cell.chunk = self
	add_child(cell)
