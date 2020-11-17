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

var default_color = Color.white
var touched_color = Color.darkorchid
var entered_color = Color.turquoise
var cell_color = default_color

var elevation = 0 setget set_elevation,get_elevation# 高度

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
		var v1 = center
		var v2 = center+hex_metrics.get_first_solid_corner(d)
		var v3 = center+hex_metrics.get_second_solid_corner(d)
		var bridge = hex_metrics.get_bridge(d)
		var v4 = v2+bridge
		var v5 = v3+bridge
		var neighbor = get_neighbor(d)
		if neighbor:
			v4.y = (neighbor.translation -  translation).y
			v5.y = v4.y
		var e1 = lerp(v2,v3,1/3)
		var e2 = lerp(v2,v3,2/3)
		add_triangle(v1,v2,e1)
		change_inner_triangle_color(v1,v2,e1)
		add_triangle(v1,e1,e2)
		change_inner_triangle_color(v1,e1,e2)
		add_triangle(v1,e2,v3)
		change_inner_triangle_color(v1,e2,v3)

		if d <= HexDirection.SE:
			if not neighbor:
				pass
			else:
				if get_edge_type(d) == hex_metrics.HexEdgeType.SLOPE:
					triangulate_edge_terraces(v2,v3,self,v4,v5,neighbor)
				else:
					add_quad(v2,v3,v4,v5)
					add_quad_color(v2,v3,v4,v5,cell_color,cell_color,neighbor.cell_color,neighbor.cell_color)

		if d <= HexDirection.E:
			var next_neighbor = get_neighbor(get_next(d))
			if not neighbor or not next_neighbor:
				pass
			else:
				var v8 = v3 + hex_metrics.get_bridge(get_next(d))
				v8.y = (next_neighbor.translation -  translation).y
				if elevation <= neighbor.elevation:
					if elevation<=next_neighbor.elevation:
						triangulate_corner(v3,self,v5,neighbor,v8,next_neighbor)
					else:
						triangulate_corner(v8,next_neighbor,v3,self,v5,neighbor)
				elif neighbor.elevation<=next_neighbor.elevation:
					triangulate_corner(v5,neighbor,v8,next_neighbor,v3,self)
				else:
					triangulate_corner(v8,next_neighbor,v3,self,v5,neighbor)


	arr[Mesh.ARRAY_VERTEX] = verts
	#arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_COLOR] = colors
	#arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices
	multimesh.mesh = ArrayMesh.new()
	# multimesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr) # No blendshapes or compression used.
	multimesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, arr) # No blendshapes or compression used.
	#multimesh.mesh.generate_triangle_mesh()

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

func add_vert(v1):
	if not v1 in verts:
		verts.push_back(v1)
	var verts_array = Array(verts)
	indices.push_back(verts_array.find(v1))

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
	var boundary =lerp(begin,right,b)
	var boundary_color = hex_metrics.color_slerp(begin_cell.cell_color,right_cell.cell_color,b)
	# add_triangle(begin,left,boundary)
	# add_triangle_color(begin,left,boundary,begin_cell.cell_color,left_cell.cell_color,boundary_color)
	triangulate_boundary_triangle(begin,begin_cell,left,left_cell,boundary,boundary_color)
	if left_cell.get_edge_type_by_cell(right_cell) == hex_metrics.HexEdgeType.SLOPE:
		triangulate_boundary_triangle(left,left_cell,right,right_cell,boundary,boundary_color)
	else:
		add_triangle(left,right,boundary)
		add_triangle_color(left,right,boundary,left_cell.cell_color,right_cell.cell_color,boundary_color)

func triangulate_corner_cliff_terraces(begin,begin_cell,left,left_cell,right,right_cell):
	var b = 1.0/ (left_cell.elevation - begin_cell.elevation)
	b = abs(b)
	var boundary =lerp(begin,left,b)
	var boundary_color = hex_metrics.color_slerp(begin_cell.cell_color,left_cell.cell_color,b)
	# add_triangle(begin,left,boundary)
	# add_triangle_color(begin,left,boundary,begin_cell.cell_color,left_cell.cell_color,boundary_color)
	triangulate_boundary_triangle(right,right_cell,begin,begin_cell,boundary,boundary_color)
	if left_cell.get_edge_type_by_cell(right_cell) == hex_metrics.HexEdgeType.SLOPE:
		triangulate_boundary_triangle(left,left_cell,right,right_cell,boundary,boundary_color)
	else:
		add_triangle(left,right,boundary)
		add_triangle_color(left,right,boundary,left_cell.cell_color,right_cell.cell_color,boundary_color)

func triangulate_boundary_triangle(begin,begin_cell,left,left_cell,boundary,boundary_color):
	var v2  = hex_metrics.terrace_lerp(begin,left,1)
	var c2 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,left_cell.cell_color,1)

	add_triangle(begin,v2,boundary)
	add_triangle_color(begin,v2,boundary,begin_cell.cell_color,c2,boundary_color)
	for i in range(2,hex_metrics.terrace_steps):
		var v1 = Vector3(v2)
		var c1 = Color(c2)
		v2 = hex_metrics.terrace_lerp(begin,left,i)
		c2 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,left_cell.cell_color,i)
		add_triangle(v1,v2,boundary)
		add_triangle_color(v1,v2,boundary,c1,c2,boundary_color)
	add_triangle(v2,left,boundary)
	add_triangle_color(v2,left,boundary,c2,left_cell.cell_color,boundary_color)

func triangulate_edge_terraces(begin_left,begin_right,begin_cell,end_left,end_right,end_cell):
	var v3 = hex_metrics.terrace_lerp(begin_left,end_left,1)
	var v4 = hex_metrics.terrace_lerp(begin_right,end_right,1)
	var c2 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,end_cell.cell_color,1)
	add_quad(begin_left,begin_right,v3,v4)
	add_quad_color(begin_left,begin_right,v3,v4,begin_cell.cell_color,begin_cell.cell_color,c2,c2)
	for i in range(2,hex_metrics.terrace_steps):
		var v1 = Vector3(v3)
		var v2 = Vector3(v4)
		var c1 = Color(c2)
		v3 = hex_metrics.terrace_lerp(begin_left,end_left,i)
		v4 = hex_metrics.terrace_lerp(begin_right,end_right,i)
		c2 = hex_metrics.terrace_color_lerp(begin_cell.cell_color,end_cell.cell_color,i)
		add_quad(v1,v2,v3,v4)
		add_quad_color(v1,v2,v3,v4,c1,c1,c2,c2)

	add_quad(v3,v4,end_left,end_right)
	add_quad_color(v3,v4,end_left,end_right,c2,c2,end_cell.cell_color,end_cell.cell_color)

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
	add_vert_color(index3,c3)
	add_vert_color(index4,c4)
	add_vert_color(index5,c5)


func _on_area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("click_hex_cell")

func _on_area_mouse_entered():
	emit_signal("entered_hex_cell")


func _on_area_mouse_exited():
	emit_signal("exited_hex_cell")

func change_color_entered():
	cell_color = entered_color
	update_mesh()
	update_neighbor_mesh()


func change_color_exited():
	cell_color = default_color
	update_mesh()
	update_neighbor_mesh()


func change_color(_cell_color):
	match _cell_color:
		"white":
			cell_color = Color.white
		"green":
			cell_color = Color.green
		"yellow":
			cell_color = Color.yellow
		"blue":
			cell_color = Color.blue
	update_mesh()
	update_neighbor_mesh()

func update_neighbor_mesh():
	for d in range(HexDirection.NE, HexDirection.NW+1):
		var neighbor = get_neighbor(d)
		if neighbor:
			neighbor.update_mesh()

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
	elevation = _elevation
	translation.y = elevation*hex_metrics.elevation_step
	translation.y = translation.y + hex_metrics.get_noise(translation).y*hex_metrics.elevation_perturb_strength
	update_mesh()
	update_neighbor_mesh()

func get_elevation():
	return elevation

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
