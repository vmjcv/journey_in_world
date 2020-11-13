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
	var horizontal_terrace_step_size = 1/terrace_steps
	var corners := PoolVector3Array([
		Vector3(0.0,0.0,-outer_radius),
		Vector3(inner_radius,0.0,-0.5*outer_radius),
		Vector3(inner_radius,0.0,0.5*outer_radius),
		Vector3(0.0,0.0,outer_radius),
		Vector3(-inner_radius,0.0,0.5*outer_radius),
		Vector3(-inner_radius,0.0,-0.5*outer_radius),
	])

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
