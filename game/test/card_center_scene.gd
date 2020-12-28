extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var all_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_all_nodes(self)
	for n in all_nodes:
		if n is MeshInstance:
			n.layers = 8

	

func get_all_nodes(node):
	for N in node.get_children():
		if N.get_child_count() > 0:
			get_all_nodes(N)
		else:
			# Do something
			all_nodes.append(N)
			
			
func _process(delta: float) -> void:
#	rotate_y(deg2rad(45) * delta)
#	rotate_z(deg2rad(-10) * delta)
#	rotate_x(deg2rad(10) * delta)
	pass

