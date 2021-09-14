extends Node
# value: int
#	Index of one of the items in the 'resolution_list'.


func main(value: Dictionary) -> void:
	OS.window_size = Utils.get_size_from_resolution_enum(int(value["value"]))
	OS.center_window()
