extends Spatial
class_name HexGrid

export(int) var width := 6
export(int) var height := 6
export(float) var unit := 10
export(Resource) var cell_obj = preload("res://scene/common/hex_cell.tscn")
export(Resource) var cell_label_obj = preload("res://scene/common/hex_cell_label.tscn")

var GUI

onready var hex_grid_canvas = $hex_grid_canvas

onready var label_canvas = $label_canvas

var cell_map = Dictionary()

var cells:Array

var multiple = 10
var hex_metrics = HexStatic.HexMetrics.new()

func _ready():
	update_canvas()
	cells = []
	cells.resize(width*height)
	var i = 0
	for z in range(height):
		for x in range(width):
			create_cell(x,z,i)
			i = i + 1 

func update_canvas():
	hex_grid_canvas.size = Vector2((width+1/2)*hex_metrics.inner_radius * 2*multiple,(height * 1.5+0.5)*hex_metrics.outer_radius*multiple)
	label_canvas.mesh.size = Vector2((width+1/2)*hex_metrics.inner_radius * 2,(height * 1.5+0.5)*hex_metrics.outer_radius)
	label_canvas.translation = Vector3((width+1/2)*hex_metrics.inner_radius,0,(height * 1.5-0.5)/2*hex_metrics.outer_radius)

func create_cell(x:int,z:int,i:int):
	var position = Vector3(0.0,0.0,0.0)
	position.x = (x +z*0.5 -floor(z / 2))* hex_metrics.inner_radius * 2
	position.y = 0
	position.z = z * hex_metrics.outer_radius * 1.5
	var position2d = Vector2(position.x*multiple,position.z*multiple)
	var cell = cell_obj.instance()
	cell.coordinates = HexStatic.HexCoordinates.from_offset_coordinates(x,z)
	cells[i] = cell
	add_child(cell)
	cell.translation = position
	var cell_label = cell_label_obj.instance()
	hex_grid_canvas.add_child(cell_label)
	cell_label.rect_position = position2d
	cell_label.text = cell.coordinates.to_string_on_separate_lines()
	
	cell.connect("click_hex_cell",self,"click_hex_cell",[x,z,cell])
	cell.connect("entered_hex_cell",self,"entered_hex_cell",[x,z,cell])
	cell.connect("exited_hex_cell",self,"exited_hex_cell",[x,z,cell])
	
	if x>0:
		cell.set_neighbor(cell.HexDirection.W,cells[i-1])
	if z>0:
		if z%2 == 1:
			cell.set_neighbor(cell.HexDirection.NW,cells[i-width])
			if x < width - 1:
				cell.set_neighbor(cell.HexDirection.NE,cells[i-width+1])
		else:
			cell.set_neighbor(cell.HexDirection.NE,cells[i-width])
			if x > 0:
				cell.set_neighbor(cell.HexDirection.NW,cells[i-width-1])
				
func click_hex_cell(x,z,cell):
	if cell_map.has(cell):
		if cell_map[cell]["color"] == GUI.get_now_color():
			# 如果二次点击则取消点击变为进入色
			cell_map.erase(cell)
			cell.change_color_entered()
		else:
			cell_map[cell]["color"] = GUI.get_now_color()
			cell.change_color(GUI.get_now_color())
	else:
		cell_map[cell] = {"color":GUI.get_now_color()}
		cell.change_color(GUI.get_now_color())
	
func entered_hex_cell(x,z,cell):
	if not cell_map.has(cell):
		cell.change_color_entered()

func exited_hex_cell(x,z,cell):
	if not cell_map.has(cell):
		cell.change_color_exited()
