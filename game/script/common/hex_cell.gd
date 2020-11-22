extends MultiMeshInstance

class_name HexCell

var verts = PoolVector3Array()
var uvs = PoolVector2Array()
var normals = PoolVector3Array()
var indices = PoolIntArray()
var colors = PoolColorArray()
var arr = []
var hex_metrics = HexStatic.HexMetrics.new()
var coordinates


var cell_color = Color.white setget set_cell_color,get_cell_color# 单元格颜色
var chunk

var elevation =  -INF setget set_elevation,get_elevation# 高度

enum HexDirection {
	NE,# 东北
	E,# 东
	SE,# 东南
	SW,# 西南
	W,# 西
	NW,#　西北
}

var neighbors = {}

signal click_hex_cell
signal entered_hex_cell
signal exited_hex_cell


func _ready():
	$Label3D.text = coordinates.to_string_on_separate_lines()
	pass

func init_mesh():
	multimesh = multimesh.duplicate()
	update_mesh()
	$Area/CollisionShape.shape = multimesh.mesh.create_convex_shape()

func update_mesh():
	arr = []
	arr.resize(Mesh.ARRAY_MAX)
	verts = PoolVector3Array()
	uvs = PoolVector2Array()
	normals = PoolVector3Array()
	indices = PoolIntArray()
	colors = PoolColorArray()

	var center = Vector3(0.0,0.0,0.0)
	for d in range(HexDirection.NE, HexDirection.NW+1):
		var e1 = HexStatic.HexEdgeVertices.new(
			center+hex_metrics.get_first_solid_corner(d),
			center+hex_metrics.get_second_solid_corner(d)
		)
		triangulate_edge_fan(center,e1)

		if d <= HexDirection.SE:
			triangulate_connection(d,self,e1)

	arr[Mesh.ARRAY_VERTEX] = verts
	#arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_COLOR] = colors
	#arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices
	multimesh.mesh = ArrayMesh.new()
	multimesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	# multimesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, arr)
	# multimesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_FAN, arr)
	#multimesh.mesh.generate_triangle_mesh()

func refresh():
	if chunk:
		chunk.refresh()
		for d in range(HexDirection.NE, HexDirection.NW+1):
			var neighbor = get_neighbor(d)
			if neighbor and neighbor.chunk!=chunk:
				neighbor.chunk.refresh()

func triangulate_connection(direction,cell,e1):
	var neighbor = get_neighbor(direction)
	if not neighbor:
		return
	var bridge = hex_metrics.get_bridge(direction)
	bridge.y =(neighbor.translation -  translation).y
	var e2 = HexStatic.HexEdgeVertices.new(
			e1.v1+bridge,
			e1.v4+bridge
		)
	if get_edge_type(direction) == hex_metrics.HexEdgeType.SLOPE:
		triangulate_edge_terraces(e1,cell,e2,neighbor)
	else:
		triangulate_edge_strip(e1,cell.cell_color,e2,neighbor.cell_color)

	var next_neighbor = get_neighbor(get_next(direction))
	if not next_neighbor or direction > HexDirection.E:
		return
	var v5 = e1.v4 + hex_metrics.get_bridge(get_next(direction))
	v5.y = (next_neighbor.translation -  cell.translation).y
	if cell.elevation <= neighbor.elevation:
		if cell.elevation<=next_neighbor.elevation:
			triangulate_corner(e1.v4,cell,e2.v4,neighbor,v5,next_neighbor)
		else:
			triangulate_corner(v5,next_neighbor,e1.v4,cell,e2.v4,neighbor)
	elif neighbor.elevation<=next_neighbor.elevation:
		triangulate_corner(e2.v4,neighbor,v5,next_neighbor,e1.v4,cell)
	else:
		triangulate_corner(v5,next_neighbor,e1.v4,cell,e2.v4,neighbor)

func change_inner_triangle_color(v1,v2,v3):
	# 改变内部三角形的颜色
	add_triangle_color(v1,v2,v3,cell_color,cell_color,cell_color)

func change_triangle_color(d,v1,v2,v3):
	# 改变连接三角形的颜色
	var neighbor = get_neighbor(d)
	var next_neighbor = get_neighbor(get_next(d))
	if not neighbor or not next_neighbor:
		return
	add_triangle_color(v1,v2,v3,cell_color,neighbor.cell_color,next_neighbor.cell_color)


func add_triangle(v1,v2,v3):
	add_vert(perturb(v1))
	add_vert(perturb(v2))
	add_vert(perturb(v3))

func add_triangle_unperturbed(v1,v2,v3):
	add_vert(v1)
	add_vert(v2)
	add_vert(v3)

func add_vert(v1):
	if not v1 in verts:
		verts.push_back(v1)
	var verts_array = Array(verts)
	indices.push_back(verts_array.find(v1))

func add_triangle_color_unperturbed(v1,v2,v3,color1,color2,color3):
	var verts_array = Array(verts)
	var index1 = verts_array.find(v1)
	var index2 = verts_array.find(v2)
	var index3 = verts_array.find(v3)

	add_vert_color(index1,color1)
	add_vert_color(index2,color2)
	add_vert_color(index3,color3)

func add_triangle_color(v1,v2,v3,color1,color2,color3):
	var verts_array = Array(verts)
	var index1 = verts_array.find(perturb(v1))
	var index2 = verts_array.find(perturb(v2))
	var index3 = verts_array.find(perturb(v3))

	add_vert_color(index1,color1)
	add_vert_color(index2,color2)
	add_vert_color(index3,color3)

func add_vert_color(index,color):
	if index == len(colors):
		colors.push_back(color)
	else:
		colors[index] = color

func triangulate_corner(bottom,bottom_cell,left,left_cell,right,right_cell):
	var left_edge_type = bottom_cell.get_edge_type_by_cell(left_cell)
	var right_edge_type = bottom_cell.get_edge_type_by_cell(right_cell)
	if left_edge_type == hex_metrics.HexEdgeType.SLOPE:
		if right_edge_type == hex_metrics.HexEdgeType.SLOPE:
			triangulate_corner_terraces(bottom,bottom_cell,left,left_cell,right,right_cell)
		elif right_edge_type == hex_metrics.HexEdgeType.FLAT:
			triangulate_corner_terraces(left,left_cell,right,right_cell,bottom,bottom_cell)
		else:
			triangulate_corner_terraces_cliff(bottom,bottom_cell,left,left_cell,right,right_cell)
	elif right_edge_type == hex_metrics.HexEdgeType.SLOPE:
		if left_edge_type == hex_metrics.HexEdgeType.FLAT:
			triangulate_corner_terraces(right,right_cell,bottom,bottom_cell,left,left_cell)
		else:
			triangulate_corner_cliff_terraces(bottom,bottom_cell,left,left_cell,right,right_cell)
	elif left_cell.get_edge_type_by_cell(right_cell) == hex_metrics.HexEdgeType.SLOPE:
		if left_cell.elevation<right_cell.elevation:
			triangulate_corner_cliff_terraces(right,right_cell,bottom,bottom_cell,left,left_cell)
		else:
			triangulate_corner_terraces_cliff(left,left_cell,right,right_cell,bottom,bottom_cell)
	else:
		add_triangle(bottom,left,right)
		add_triangle_color(bottom,left,right,bottom_cell.cell_color,left_cell.cell_color,right_cell.cell_color)

func triangulate_corner_terraces(begin,begin_cell,left,left_cell,right,right_cell):
	var v3  = hex_metrics.terrace_lerp(begin,left,1)
	var v4  = hex_metrics.terrace_lerp(begin,right,1)
	var c3 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,left_cell.cell_color,1)
	var c4 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,right_cell.cell_color,1)
	add_triangle(begin,v3,v4)
	add_triangle_color(begin,v3,v4,begin_cell.cell_color,c3,c4)

	for i in range(2,hex_metrics.terrace_steps):
		var v1 = Vector3(v3)
		var v2 = Vector3(v4)
		var c1 = Color(c3)
		var c2 = Color(c4)
		v3 = hex_metrics.terrace_lerp(begin,left,i)
		v4 = hex_metrics.terrace_lerp(begin,right,i)
		c3 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,left_cell.cell_color,i)
		c4 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,right_cell.cell_color,i)
		add_quad(v1,v2,v3,v4)
		add_quad_color(v1,v2,v3,v4,c1,c2,c3,c4)

	add_quad(v3,v4,left,right)
	add_quad_color(v3,v4,left,right,c3,c4,left_cell.cell_color,right_cell.cell_color)
	pass

func triangulate_corner_terraces_cliff(begin,begin_cell,left,left_cell,right,right_cell):
	var b = 1.0/ (right_cell.elevation - begin_cell.elevation)
	b = abs(b)
	var boundary =lerp(perturb(begin),perturb(right),b)
	var boundary_color = hex_metrics.color_slerp(begin_cell.cell_color,right_cell.cell_color,b)
	triangulate_boundary_triangle(begin,begin_cell,left,left_cell,boundary,boundary_color)
	if left_cell.get_edge_type_by_cell(right_cell) == hex_metrics.HexEdgeType.SLOPE:
		triangulate_boundary_triangle(left,left_cell,right,right_cell,boundary,boundary_color)
	else:
		add_triangle_unperturbed(perturb(left),perturb(right),boundary)
		add_triangle_color_unperturbed(perturb(left),perturb(right),boundary,left_cell.cell_color,right_cell.cell_color,boundary_color)

func triangulate_corner_cliff_terraces(begin,begin_cell,left,left_cell,right,right_cell):
	var b = 1.0/ (left_cell.elevation - begin_cell.elevation)
	b = abs(b)
	var boundary =lerp(perturb(begin),perturb(left),b)
	var boundary_color = hex_metrics.color_slerp(begin_cell.cell_color,left_cell.cell_color,b)
	triangulate_boundary_triangle(right,right_cell,begin,begin_cell,boundary,boundary_color)
	if left_cell.get_edge_type_by_cell(right_cell) == hex_metrics.HexEdgeType.SLOPE:
		triangulate_boundary_triangle(left,left_cell,right,right_cell,boundary,boundary_color)
	else:
		add_triangle_unperturbed(perturb(left),perturb(right),boundary)
		add_triangle_color_unperturbed(perturb(left),perturb(right),boundary,left_cell.cell_color,right_cell.cell_color,boundary_color)

func triangulate_boundary_triangle(begin,begin_cell,left,left_cell,boundary,boundary_color):
	var v2  = perturb(hex_metrics.terrace_lerp(begin,left,1))
	var c2 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,left_cell.cell_color,1)

	add_triangle_unperturbed(perturb(begin),v2,boundary)
	add_triangle_color_unperturbed(perturb(begin),v2,boundary,begin_cell.cell_color,c2,boundary_color)
	for i in range(2,hex_metrics.terrace_steps):
		var v1 = Vector3(v2)
		var c1 = Color(c2)
		v2 = perturb(hex_metrics.terrace_lerp(begin,left,i))
		c2 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,left_cell.cell_color,i)
		add_triangle_unperturbed(v1,v2,boundary)
		add_triangle_color_unperturbed(v1,v2,boundary,c1,c2,boundary_color)
	add_triangle_unperturbed(v2,perturb(left),boundary)
	add_triangle_color_unperturbed(v2,perturb(left),boundary,c2,left_cell.cell_color,boundary_color)

func triangulate_edge_terraces(begin,begin_cell,end,end_cell):
	var e2 = HexStatic.HexEdgeVertices.terrace_lerp(begin,end,1)
	var c2 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,end_cell.cell_color,1)
	triangulate_edge_strip(begin,begin_cell.cell_color,e2,c2)
	for i in range(2,hex_metrics.terrace_steps):
		var e1 = e2
		var c1 = Color(c2)
		e2 = HexStatic.HexEdgeVertices.terrace_lerp(begin,end,i)
		c2 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,end_cell.cell_color,i)
		triangulate_edge_strip(e1,c1,e2,c2)
	triangulate_edge_strip(e2,c2,end,end_cell.cell_color)

func add_quad(v2,v3,v4,v5):
	add_vert(perturb(v2))
	add_vert(perturb(v4))
	add_vert(perturb(v5))
	add_vert(perturb(v3))
	add_vert(perturb(v2))
	add_vert(perturb(v5))

func add_quad_color(v2,v3,v4,v5,c2,c3,c4,c5):
	var verts_array = Array(verts)
	var index2 = verts_array.find(perturb(v2))
	var index3 = verts_array.find(perturb(v3))
	var index4 = verts_array.find(perturb(v4))
	var index5 = verts_array.find(perturb(v5))

	add_vert_color(index2,c2)
	add_vert_color(index4,c4)
	add_vert_color(index5,c5)
	add_vert_color(index3,c3)

func _on_area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("click_hex_cell")

func _on_area_mouse_entered():
	emit_signal("entered_hex_cell")


func _on_area_mouse_exited():
	emit_signal("exited_hex_cell")

func get_neighbor(direction):
	return neighbors.get(direction,null)

func set_neighbor(direction,cell):
	neighbors[direction] = cell
	cell.neighbors[direction_opposite(direction)] = self

func get_previous(direction):
	return (direction+5)%6

func get_next(direction):
	return (direction+1)%6

func direction_opposite(direction):
	if direction<3:
		return direction+3
	else:
		return direction-3

func set_elevation(_elevation):
	if elevation ==_elevation:
		return
	elevation = _elevation
	translation.y = elevation*hex_metrics.elevation_step
	translation.y = translation.y + hex_metrics.get_noise(translation).y*hex_metrics.elevation_perturb_strength
	refresh()

func get_elevation():
	return elevation

func set_cell_color(_cell_color):
	if cell_color == _cell_color:
		return
	cell_color = _cell_color
	refresh()

func get_cell_color():
	return cell_color

func get_edge_type(direction):
	var neighbor = get_neighbor(direction)
	return hex_metrics.get_edge_type(elevation,neighbor.elevation)

func get_edge_type_by_cell(cell):
	return hex_metrics.get_edge_type(elevation,cell.elevation)

func perturb(position):
	var sample = hex_metrics.get_noise(translation+position)
	sample = sample *hex_metrics.cell_perturb_strength
	var cur_position = Vector3(position)
	cur_position.x =cur_position.x+ sample.x
	#cur_position.y =cur_position.y+ sample.y
	cur_position.z =cur_position.z+ sample.z
	return cur_position

func triangulate_edge_fan(center,edge):
	add_triangle(center,edge.v1,edge.v2)
	change_inner_triangle_color(center,edge.v1,edge.v2)
	add_triangle(center,edge.v2,edge.v3)
	change_inner_triangle_color(center,edge.v2,edge.v3)
	add_triangle(center,edge.v3,edge.v4)
	change_inner_triangle_color(center,edge.v3,edge.v4)
func triangulate_edge_strip(e1,c1,e2,c2):
	add_quad(e1.v1,e1.v2,e2.v1,e2.v2)
	add_quad_color(e1.v1,e1.v2,e2.v1,e2.v2,c1,c1,c2,c2)
	add_quad(e1.v2,e1.v3,e2.v2,e2.v3)
	add_quad_color(e1.v2,e1.v3,e2.v2,e2.v3,c1,c1,c2,c2)
	add_quad(e1.v3,e1.v4,e2.v3,e2.v4)
	add_quad_color(e1.v3,e1.v4,e2.v3,e2.v4,c1,c1,c2,c2)
