extends Resource
class_name HexStatic
class HexMetrics:
	var outer_radius := 10.0
	var inner_radius := outer_radius * 0.866025404
	var solid_factor = 0.75
	var blend_factor = 1 - solid_factor
	var elevation_step = 5 # 高度步进
	var terraces_per_slope = 2 # 梯田数量
	var terrace_steps = terraces_per_slope *2 +1
	var horizontal_terrace_step_size = 1.0/terrace_steps
	var vertical_terrace_step_size = 1.0/(terraces_per_slope+1)
	var corners := PoolVector3Array([
		Vector3(0.0,0.0,-outer_radius),
		Vector3(inner_radius,0.0,-0.5*outer_radius),
		Vector3(inner_radius,0.0,0.5*outer_radius),
		Vector3(0.0,0.0,outer_radius),
		Vector3(-inner_radius,0.0,0.5*outer_radius),
		Vector3(-inner_radius,0.0,-0.5*outer_radius),
	])

	enum HexEdgeType {
		FLAT,# 平坦
		SLOPE,# 倾斜
		CLIFF,# 悬崖
	}

	func get_edge_type(height1,height2):
		if height1 == height2:
			return HexEdgeType.FLAT
		var delta = height2 - height1
		if(abs(delta)<=1):
			return HexEdgeType.SLOPE
		return HexEdgeType.CLIFF
	func get_first_corner(direction):
		return corners[direction]

	func get_second_corner(direction):
		return corners[(direction+1)%len(corners)]

	func get_first_solid_corner(direction):
		return corners[direction]*solid_factor

	func get_second_solid_corner(direction):
		return corners[(direction+1)%len(corners)]*solid_factor

	func get_bridge(direction):
		return (corners[direction]+corners[(direction+1)%len(corners)])*blend_factor

	func terrace_lerp(a,b,step):
		var c = Vector3(0,0,0)
		var h = step*horizontal_terrace_step_size
		c.x = a.x+ (b.x-a.x)*h
		c.z = a.z+ (b.z-a.z)*h
		var v = floor((step+1.0)/2) * vertical_terrace_step_size
		c.y = a.y+ (b.y-a.y)*v
		return c

	func terrace_color_lerp(a,b,step):
		var h = step * horizontal_terrace_step_size
		return color_slerp(a,b,h)

	func color_slerp(a,b,h):
		var cur_color = Color(0)
		cur_color.r = lerp(a.r,b.r,h)
		cur_color.g = lerp(a.g,b.g,h)
		cur_color.a = lerp(a.a,b.a,h)
		cur_color.b = lerp(a.b,b.b,h)
		return cur_color

class HexCoordinates:
	export(int) var x
	export(int) var z
	export(int) var y setget set_y,get_y
	func _init(_x,_z):
		x = _x
		z = _z

	static func from_offset_coordinates(_x,_z):
		return HexCoordinates.new(_x-floor(_z/2),_z)

	func _to_string():
		return "(%d, %d, %d)"%[x,get_y(),z]

	func to_string_on_separate_lines():
		return "%d\n%d\n%d"%[x,get_y(),z]

	func set_y(value):
		pass

	func get_y():
		return -x-z
