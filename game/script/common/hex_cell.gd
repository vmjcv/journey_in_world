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
var index

var elevation setget set_elevation,get_elevation# 高度


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
		
		var v6 = v1+hex_metrics.get_first_corner(d)
		var v7 = v1+hex_metrics.get_second_corner(d)
		add_triangle(v1,v2,v3)
		change_inner_triangle_color(v1,v2,v3)
		
		if d <= HexDirection.SE:
			var neighbor = get_neighbor(d)
			if not neighbor:
				pass
			else:
				add_quad(v2,v3,v4,v5)
				change_triangulate_color(d,v2,v3,v4,v5)
		if d <= HexDirection.E:
			var neighbor = get_neighbor(d)
			var next_neighbor = get_neighbor(get_next(d))
			if not neighbor or not next_neighbor:
				pass
			else:
				var third_point = v3 + hex_metrics.get_bridge(get_next(d))
				add_triangle(v3,v5,third_point)
				change_triangle_color(d,v3,v5,third_point)

	arr[Mesh.ARRAY_VERTEX] = verts
	#arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_COLOR] = colors
	#arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_INDEX] = indices
	multimesh.mesh = ArrayMesh.new()
	multimesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr) # No blendshapes or compression used.
	#multimesh.mesh.generate_triangle_mesh()

func change_inner_triangle_color(v1,v2,v3):
	# 改变内部三角形的颜色
	add_triangle_color(v1,v2,v3,cell_color,cell_color,cell_color)

func change_triangulate_color(d,v2,v3,v4,v5):
	# 改变连接四边形的颜色
	var neighbor = get_neighbor(d)
	if not neighbor:
		return
	add_quad_color(v2,v3,v4,v5,cell_color,cell_color,neighbor.cell_color,neighbor.cell_color)

func change_triangle_color(d,v1,v2,v3):
	# 改变连接三角形的颜色
	var neighbor = get_neighbor(d)
	var next_neighbor = get_neighbor(get_next(d))
	if not neighbor or not next_neighbor:
		return 
	add_triangle_color(v1,v2,v3,cell_color,neighbor.cell_color,next_neighbor.cell_color)


func add_triangle(v1,v2,v3):
	add_vert(v1)
	add_vert(v2)
	add_vert(v3)
	
func add_vert(v1):
	if not v1 in verts:
		verts.push_back(v1)
	var verts_array = Array(verts)
	indices.push_back(verts_array.find(v1))

func add_triangle_color(v1,v2,v3,color1,color2,color3):
	var verts_array = Array(verts)
	var index1 = verts_array.find(v1)
	var index2 = verts_array.find(v2)
	var index3 = verts_array.find(v3)
	
	add_vert_color(index1,color1)
	add_vert_color(index2,color2)
	add_vert_color(index3,color3)

func add_vert_color(index,color):
	if index == len(colors):
		colors.push_back(color)
	else:
		colors[index] = color

func add_quad(v2,v3,v4,v5):
	add_vert(v2)
	add_vert(v4)
	add_vert(v5)
	add_vert(v3)
	add_vert(v2)
	add_vert(v5)
	
func add_quad_color(v2,v3,v4,v5,color2,color3,color4,color5):
	var verts_array = Array(verts)
	var index2 = verts_array.find(v2)
	var index3 = verts_array.find(v3)
	var index4 = verts_array.find(v4)
	var index5 = verts_array.find(v5)

	add_vert_color(index2,color2)
	add_vert_color(index3,color3)
	add_vert_color(index4,color4)
	add_vert_color(index5,color5)


func _on_area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("click_hex_cell")
		
func _on_area_mouse_entered():
	emit_signal("entered_hex_cell")


func _on_area_mouse_exited():
	emit_signal("exited_hex_cell")

func change_color_entered():
	cell_color = entered_color
	update_mesh_color()
	update_neighbor_mesh_color()


func change_color_exited():
	cell_color = default_color
	update_mesh_color()
	update_neighbor_mesh_color()


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
	update_mesh_color()
	update_neighbor_mesh_color()

func update_mesh_color():
	colors = PoolColorArray()
	var center = Vector3(0.0,0.0,0.0)
	for d in range(HexDirection.NE, HexDirection.NW+1):
		var v1 = center
		var v2 = center+hex_metrics.get_first_solid_corner(d)
		var v3 = center+hex_metrics.get_second_solid_corner(d)
		var bridge = hex_metrics.get_bridge(d)
#		var v4 = center+hex_metrics.get_first_corner(d)
#		var v5 = center+hex_metrics.get_second_corner(d)
		var v4 = v2+bridge
		var v5 = v3+bridge
		
		var v6 = v1+hex_metrics.get_first_corner(d)
		var v7 = v1+hex_metrics.get_second_corner(d)
		change_inner_triangle_color(v1,v2,v3)
		if d <= HexDirection.SE:
			var neighbor = get_neighbor(d)
			if not neighbor:
				pass
			else:
				change_triangulate_color(d,v2,v3,v4,v5)

		if d <= HexDirection.E:
			var neighbor = get_neighbor(d)
			var next_neighbor = get_neighbor(get_next(d))
			if not neighbor or not next_neighbor:
				pass
			else:
				var third_point = v3 + hex_metrics.get_bridge(get_next(d))
				change_triangle_color(d,v3,v5,third_point)
		
	multimesh.mesh = null
	multimesh.mesh = ArrayMesh.new()
	arr[Mesh.ARRAY_COLOR] = colors
	multimesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)

func update_neighbor_mesh_color():
	for d in range(HexDirection.NE, HexDirection.NW+1):
		var neighbor = get_neighbor(d)
		if neighbor:
			neighbor.update_mesh_color()

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
	pass
	
func get_elevation():
	return elevation
