extends Node
# value: int
#	Index of one of the items in the 'resolution_list'.


func main(value: Dictionary) -> void:
	Utils.change_display_mode(int(value["value"]))
