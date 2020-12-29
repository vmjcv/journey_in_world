extends Viewport

var all_nodes = []

export var camera_layer = 8

func _ready():
	get_all_nodes(self)
	change_child_camera_layer()

func get_all_nodes(node):
	for N in node.get_children():
		if N.get_child_count() > 0:
			get_all_nodes(N)
		else:
			all_nodes.append(N)

func change_child_camera_layer():
	for n in all_nodes:
		if n is VisualInstance:
			n.layers = camera_layer
		if n is Camera:
			n.cull_mask = camera_layer
