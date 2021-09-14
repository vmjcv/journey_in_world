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

func remove_all_child(node) -> void:
	for child in node.get_children():
		node.remove_child(child)

func remove_all_child_in_group(node,group: String) -> void:
	for child in node.get_children():
		if child.is_in_group(group):
			node.remove_child(child)

func get_size_from_resolution_enum(id):
	var window_size
	match id:
		Types.Resolution.SMALL:
			window_size = Vector2(1280,720)
		Types.Resolution.DEFAULT:
			window_size = Vector2(1920,1080)
		Types.Resolution.MIDDLE:
			window_size = Vector2(2560,1440)
		Types.Resolution.BIG:
			window_size = Vector2(3200,1800)
		Types.Resolution.BIG_BIG:
			window_size = Vector2(3840,2160)
	return window_size

func get_language_from_resolution_enum(id):
	var language_name
	match id:
		Types.GameLanguage.EN:
			language_name = "en"
		Types.GameLanguage.ZH:
			language_name = "zh"
	return language_name


func change_display_mode(id):
	match id:
		Types.DisplayMode.BORDER:
			OS.window_borderless = false
			OS.window_fullscreen = false
		Types.DisplayMode.FULLSCREEN:
			OS.window_borderless = false
			OS.window_fullscreen = true
		Types.DisplayMode.BORDERLESS:
			OS.window_borderless = true
			OS.window_fullscreen = false
		
