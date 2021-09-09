extends Node
# -------------------------------------------------------------------------------------------------
func remove_signal_connections(node: Node, signal_name: String) -> void:
	for conn in node.get_signal_connection_list(signal_name):
		node.disconnect(conn.signal, conn.target, conn.method)

# -------------------------------------------------------------------------------------------------
func is_mouse_in_control(control: Control) -> bool:
	if control.visible:
		var pos = get_viewport().get_mouse_position()
		var rect = control.get_global_rect()
		return rect.has_point(pos)
	return false


# -------------------------------------------------------------------------------------------------
func return_timestamp_string() -> String:
	var today := OS.get_datetime()
	return "%s%s%s_%s%s%s" % [today.day, today.month, today.year, today.hour, today.minute, today.second]

# -------------------------------------------------------------------------------------------------
func remove_group_from_all_nodes(group: String) -> void:
	for n in get_tree().get_nodes_in_group(group):
		n.remove_from_group(group)

