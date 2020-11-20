extends Spatial
class_name HexGrid

export(int) var chunk_count_x := 4
export(int) var chunk_count_z := 3

var cell_count_x
var cell_count_z

export(Resource) var cell_obj = preload("res://scene/common/hex_cell.tscn")
export(Resource) var chunk_obj = preload("res://scene/common/hex_grid_chunk.tscn")
#export(Resource) var cell_label_obj = preload("res://scene/common/hex_cell_label.tscn")

var GUI

var cell_map = Dictionary()

var cells:Array
var chunks:Array

var multiple = 10
var hex_metrics = HexStatic.HexMetrics.new()

func _ready():
	cell_count_x = chunk_count_x * hex_metrics.chunk_size_x
	cell_count_z = chunk_count_z * hex_metrics.chunk_size_z
	create_chunks()
	create_cells()

func create_chunks():
	chunks = []
	chunks.resize(chunk_count_x*chunk_count_z)
	var i = 0
	for z in range(chunk_count_z):
		for x in range(chunk_count_x):
			create_chunk(x,z,i)
			i = i + 1
	pass

func create_chunk(x:int,z:int,i:int):
	var position = Vector3(0.0,0.0,0.0)
	# position.x = (x +z*0.5 -floor(z / 2))* hex_metrics.inner_radius * 2
	# position.y = 0
	# position.z = z * hex_metrics.outer_radius * 1.5
	# var position2d = Vector2(position.x*multiple,position.z*multiple)
	var chunk = chunk_obj.instance()
	chunks[i] = chunk
	chunk.translation = position
	add_child(chunk)

func create_cells():
	cells = []
	cells.resize(cell_count_x*cell_count_z)
	var i = 0
	for z in range(cell_count_z):
		for x in range(cell_count_x):
			create_cell(x,z,i)
			i = i + 1
	for cell in cells:
		cell.init_mesh()
		cell.elevation = randi()%7
		# cell.elevation = 0
		var color_map =["white","green","yellow","blue"]
		var index = randi()%4
		cell.change_color(color_map[index])
		cell_map[cell] = {"color":color_map[index]}


func create_cell(x:int,z:int,i:int):
	var position = Vector3(0.0,0.0,0.0)
	position.x = (x +z*0.5 -floor(z / 2))* hex_metrics.inner_radius * 2
	position.y = 0
	position.z = z * hex_metrics.outer_radius * 1.5
	var position2d = Vector2(position.x*multiple,position.z*multiple)
	var cell = cell_obj.instance()
	cell.coordinates = HexStatic.HexCoordinates.from_offset_coordinates(x,z)
	cells[i] = cell

	cell.translation = position

	cell.connect("click_hex_cell",self,"click_hex_cell",[x,z,cell])
	cell.connect("entered_hex_cell",self,"entered_hex_cell",[x,z,cell])
	cell.connect("exited_hex_cell",self,"exited_hex_cell",[x,z,cell])

	if x>0:
		cell.set_neighbor(cell.HexDirection.W,cells[i-1])
	if z>0:
		if z%2 == 1:
			cell.set_neighbor(cell.HexDirection.NW,cells[i-cell_count_x])
			if x < cell_count_x - 1:
				cell.set_neighbor(cell.HexDirection.NE,cells[i-cell_count_x+1])
		else:
			cell.set_neighbor(cell.HexDirection.NE,cells[i-cell_count_x])
			if x > 0:
				cell.set_neighbor(cell.HexDirection.NW,cells[i-cell_count_x-1])
	add_cell_to_trunk(x,z,cell)
				# add_child(cell)

func add_cell_to_trunk(x,z,cell):
	var chunk_x = floor(x / hex_metrics.chunk_size_x)
	var chunk_z = floor(z / hex_metrics.chunk_size_z)
	var chunk = chunks[chunk_x+chunk_z*chunk_count_x]
	var local_x = x - hex_metrics.chunk_size_x*chunk_x
	var local_z = z - hex_metrics.chunk_size_z*chunk_z
	chunk.add_cell(local_x+local_z*hex_metrics.chunk_size_x,cell)

func click_hex_cell(x,z,cell):
	if cell_map.has(cell):
		if cell_map[cell]["color"] == GUI.get_now_color():
			# 如果二次点击则取消点击变为进入色
			cell_map.erase(cell)
			cell.change_color_entered()
		else:
			cell_map[cell]["color"] = GUI.get_now_color()
			cell.change_color(GUI.get_now_color())
			cell.set_elevation(GUI.get_now_elevation())
	else:
		cell_map[cell] = {"color":GUI.get_now_color()}
		cell.change_color(GUI.get_now_color())
		cell.set_elevation(GUI.get_now_elevation())

func entered_hex_cell(x,z,cell):
	if not cell_map.has(cell):
		cell.change_color_entered()

func exited_hex_cell(x,z,cell):
	if not cell_map.has(cell):
		cell.change_color_exited()
