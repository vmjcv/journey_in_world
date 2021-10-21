extends Panel
class_name Menubar

# -------------------------------------------------------------------------------------------------
const PROJECT_TAB = preload("res://UI/components/tab.tscn")

# -------------------------------------------------------------------------------------------------
signal card_project_selected(project_id)
signal card_project_closed(project_id)
signal create_new_card_project

# -------------------------------------------------------------------------------------------------
onready var _tabs_container: HBoxContainer = $Left/Tabs
export var _main_menu_path: NodePath
var _active_file_tab: Tab
var _tabs_map: Dictionary # Dictonary<project_id, ProjectTab>

# -------------------------------------------------------------------------------------------------
func make_tab(project) -> void:
	var tab: Tab = PROJECT_TAB.instance()
	tab.title = project.get_filename()
	tab.id = project.id
	tab.connect("close_requested", self, "_on_tab_close_requested")
	tab.connect("selected", self, "_on_tab_selected")
	_tabs_container.add_child(tab)
	_tabs_map[project.id] = tab

# ------------------------------------------------------------------------------------------------
func has_tab(project) -> bool:
	return _tabs_map.has(project.id)

# ------------------------------------------------------------------------------------------------
func remove_tab(project) -> void:
	if _tabs_map.has(project.id):
		var tab = _tabs_map[project.id]
		tab.disconnect("close_requested", self, "_on_tab_close_requested")
		tab.disconnect("selected", self, "_on_tab_selected")
		_tabs_container.remove_child(tab)
		_tabs_map.erase(project.id)
		tab.call_deferred("free")

# ------------------------------------------------------------------------------------------------
func remove_all_tabs() -> void:
	for project_id in _tabs_map.keys():
#		var project: CardProject = ProjectManager.get_project_by_id(project_id)
#		remove_tab(project)
		pass
	_tabs_map.clear()
	_active_file_tab = null

# ------------------------------------------------------------------------------------------------
func update_tab_title(project) -> void:
	if _tabs_map.has(project.id):
		var name = project.get_filename()
		if project.dirty:
			name += " (*)"
		_tabs_map[project.id].title = name

# ------------------------------------------------------------------------------------------------
func set_tab_active(project) -> void:
	if _tabs_map.has(project.id):
		var tab: Tab = _tabs_map[project.id]
		_active_file_tab = tab
		for c in _tabs_container.get_children():
			c.set_active(false)
		tab.set_active(true)
	else:
		print_debug("Project tab not found")

# -------------------------------------------------------------------------------------------------
func _on_tab_close_requested(tab: Tab) -> void:
	emit_signal("card_project_closed", tab.id)

# -------------------------------------------------------------------------------------------------
func _on_tab_selected(tab: Tab) -> void:
	emit_signal("card_project_selected", tab.id)

# -------------------------------------------------------------------------------------------------
func _on_NewFileButton_pressed():
	 emit_signal("create_new_card_project")

# -------------------------------------------------------------------------------------------------
func _on_MenuButton_pressed():
	get_node(_main_menu_path).popup()

# -------------------------------------------------------------------------------------------------
func get_first_project_id() -> int:
	if _tabs_container.get_child_count() == 0:
		return -1
	return _tabs_container.get_child(0).id
