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
	multimesh.mesh = multimesh.mesh.duplicate()
	update_mesh()
	$Area/CollisionShape.shape = multimesh.mesh.create_convex_shape()
	#material_override = material_override.duplicate(true)
	#material_override.albedo_color = default_color

func update_mesh():
	arr = []
	arr.resize(Mesh.ARRAY_MAX)
	verts = PoolVector3Array()
	uvs = PoolVector2Array()
	normals = PoolVector3Array()
	indices = PoolIntArray()
	colors = PoolColorArray()
	

	var center = Vector3(0.0,0.0,0.0)
	for i in range(6):
		add_triangle(center,center+hex_metrics.corners[(i+1)%6],center+hex_metrics.corners[i])
		add_color(cell_color,cell_color,cell_color)
	arr[Mesh.ARRAY_VERTEX] = verts
	#arr[Mesh.ARRAY_TEX_UV] = uvs
	arr[Mesh.ARRAY_COLOR] = colors
	#arr[Mesh.ARRAY_NORMAL] = normals
	#arr[Mesh.ARRAY_INDEX] = indices
	multimesh.mesh = ArrayMesh.new()
	multimesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr) # No blendshapes or compression used.
	#multimesh.mesh.generate_triangle_mesh()


func add_triangle(v1,v2,v3):
	verts.push_back(v1)
	verts.push_back(v2)
	verts.push_back(v3)
	pass

func add_color(color1,color2,color3):
	colors.push_back(color1)
	colors.push_back(color2)
	colors.push_back(color3)
	pass


func _on_area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("click_hex_cell")
		
func _on_area_mouse_entered():
	emit_signal("entered_hex_cell")


func _on_area_mouse_exited():
	emit_signal("exited_hex_cell")

func change_color_entered():
	#material_override.albedo_color = entered_color
	cell_color = entered_color
	update_mesh_color()

func change_color_exited():
	#material_override.albedo_color = default_color
	cell_color = default_color
	update_mesh_color()


func change_color(_cell_color):
	match _cell_color:
		"white":
			#material_override.albedo_color = Color.white
			cell_color = Color.white
		"green":
			#material_override.albedo_color = Color.green
			cell_color = Color.green
		"yellow":
			#material_override.albedo_color = Color.yellow
			cell_color = Color.yellow
		"blue":
			#material_override.albedo_color = Color.blue
			cell_color = Color.blue
	update_mesh_color()

func update_mesh_color():
	for i in range(colors.size()):
		colors[i] = cell_color
	multimesh.mesh = ArrayMesh.new()
	#multimesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	print("update_mesh_color")
	print(multimesh.mesh.get_surface_count())

func get_neighbor(direction):
	return neighbors[direction]

func set_neighbor(direction,cell):
	neighbors[direction] = cell
	cell.neighbors[direction_opposite(direction)] = cell

func direction_opposite(direction):
	if direction<3:
		return direction+3
	else:
		return direction-3
