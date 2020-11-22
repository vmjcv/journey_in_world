extends Spatial
class_name HexGridChunk
var hex_metrics = HexStatic.HexMetrics.new()
var cells:Array
var need_update

func _ready():
	cells = []
	cells.resize(hex_metrics.chunk_size_x*hex_metrics.chunk_size_z)

func refresh():
	# 更新块区内所有的模型内容
	need_update = true

func add_cell(index,cell):
	cells[index] = cell
	cell.chunk = self
	add_child(cell)

func _process(delta):
	if need_update:
		for cell in cells:
			cell.update_mesh()
		need_update = false
