extends Node
# value: float
#	A value between 0 and 1. The volume of the bus.
# bus_name: String
#	Name of the bus that'll be affected.


func main(value: Dictionary) -> void:
	InputMap.load_from_globals()
	var cur_value = value["value"]
	var input_map = cur_value
	for action_name in input_map:
		InputMap.action_erase_events(action_name)
		for event in input_map[action_name]:
			InputMap.action_add_event(action_name, event)
