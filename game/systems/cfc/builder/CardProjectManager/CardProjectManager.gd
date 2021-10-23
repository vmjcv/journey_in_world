extends Node

# -------------------------------------------------------------------------------------------------
var _open_projects: Array # Array<Project>
var _active_project
var card_info_ui
var card_preview_ui
signal change_metadata
signal change_card_info_ui
func _ready():
	connect("change_card_info_ui",self,"updata_data_from_card_info_ui")

# -------------------------------------------------------------------------------------------------
func read_project_list() -> void:
	pass

# -------------------------------------------------------------------------------------------------
func make_project_active(project) -> void:
	if !project.loaded:
		_load_project(project)
	_active_project = project
	# 更新激活数据后重置卡片信息设置界面和预览界面
	emit_signal("change_metadata")

# -------------------------------------------------------------------------------------------------
func get_active_project():
	return _active_project

# -------------------------------------------------------------------------------------------------
func remove_project(project) -> void:
	var index := _open_projects.find(project)
	if index >= 0:
		_open_projects.remove(index)

	if project == _active_project:
		_active_project = null
	project.clear()

# -------------------------------------------------------------------------------------------------
func remove_all_projects() -> void:
	for project in _open_projects:
		remove_project(project)
	_open_projects.clear()
	_active_project = null

# -------------------------------------------------------------------------------------------------
func add_project(filepath: String = ""):
	# Check if already open
	if !filepath.empty():
		var p = get_open_project_by_filepath(filepath)
		if p != null:
			print_debug("Project already in open project list")
			return p

	var project := CardProject.new()
	project.id = _open_projects.size()
	project.filepath = filepath
	project.loaded = project.filepath.empty() # empty/unsaved/new projects are loaded by definition
	_open_projects.append(project)
	project.meta_data = CardProjectMetadata.new()
	return project

# -------------------------------------------------------------------------------------------------
func save_project(project) -> void:
	Serializer.save_card_project(project)
	project.loaded = false
	project.dirty = false
	make_project_active(project)
	

# -------------------------------------------------------------------------------------------------
func save_all_projects() -> void:
	for p in _open_projects:
		if !p.filepath.empty() && p.loaded && p.dirty:
			save_project(p)

# -------------------------------------------------------------------------------------------------
func _load_project(project) -> void:
	if !project.loaded:
		Serializer.load_card_project(project)
		project.loaded = true
	else:
		print_debug("Trying to load already loaded project")

# -------------------------------------------------------------------------------------------------
func get_open_project_by_filepath(filepath: String):
	for p in _open_projects:
		if p.filepath == filepath:
			return p
	return null

# -------------------------------------------------------------------------------------------------
func get_project_by_id(id: int):
	for p in _open_projects:
		if p.id == id:
			return p
	return null

# -------------------------------------------------------------------------------------------------
func has_unsaved_changes() -> bool:
	for p in _open_projects:
		if p.dirty:
			return true
	return false

# -------------------------------------------------------------------------------------------------
func has_unsaved_projects() -> bool:
	for p in _open_projects:
		if p.dirty && p.filepath.empty():
			return true
	return false

# -------------------------------------------------------------------------------------------------
func get_project_count() -> int:
	return _open_projects.size()

# -------------------------------------------------------------------------------------------------
func is_active_project(project) -> bool:
	return _active_project == project

func updata_data_from_card_info_ui():
	var _dirty = card_info_ui.dirty
	_active_project.meta_data.update_data_from_ui(card_info_ui)
	_active_project.dirty = _dirty
