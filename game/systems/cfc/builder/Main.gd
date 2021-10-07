extends Control

# -------------------------------------------------------------------------------------------------
onready var _menubar: Menubar = $Menubar
onready var _file_dialog: FileDialog = $FileDialog
onready var _main_menu: MainMenu = $MainMenu

var _ui_visible := true
var _player_enabled := false

# -------------------------------------------------------------------------------------------------
func _ready():
	# Init stuff
	var docs_folder = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	_file_dialog.current_dir = docs_folder

	# Signals
	get_tree().connect("files_dropped", self, "_on_files_dropped")

	_menubar.connect("create_new_project", self, "_on_create_new_project")
	_menubar.connect("project_selected", self, "_on_project_selected")
	_menubar.connect("project_closed", self, "_on_project_closed")

	_main_menu.connect("open_project", self, "_on_open_project")
	_main_menu.connect("save_project", self, "_on_save_project")
	_main_menu.connect("save_project_as", self, "_on_save_project_as")

	# Create the default project
	_create_active_default_project()

# -------------------------------------------------------------------------------------------------
func _exit_tree():
	_menubar.remove_all_tabs()
	ProjectManager.remove_all_projects()

# -------------------------------------------------------------------------------------------------
func _process(delta):
	_handle_input_actions()

	# Update tab title
	var active_project: CardProject = ProjectManager.get_active_project()
	if active_project != null:
		_menubar.update_tab_title(active_project)


# -------------------------------------------------------------------------------------------------
func _on_files_dropped(files: PoolStringArray, screen: int) -> void:
	for file in files:
		if Utils.is_valid_card_file(file):
			_on_open_project(file)

# -------------------------------------------------------------------------------------------------
func _make_project_active(project: CardProject) -> void:
	ProjectManager.make_project_active(project)
	if !_menubar.has_tab(project):
		_menubar.make_tab(project)
	_menubar.set_tab_active(project)


# -------------------------------------------------------------------------------------------------
func _create_active_default_project() -> void:
	var default_project: CardProject = ProjectManager.add_project()
	_make_project_active(default_project)

# -------------------------------------------------------------------------------------------------
func _save_project(project: CardProject) -> void:
	var meta_data = ProjectMetadata.make_dict(_canvas)
	project.meta_data = meta_data
	ProjectManager.save_project(project)
	_menubar.update_tab_title(project)

# -------------------------------------------------------------------------------------------------
func _on_create_new_project() -> void:
	_create_active_default_project()

# -------------------------------------------------------------------------------------------------
func _on_project_selected(project_id: int) -> void:
	var project: CardProject = ProjectManager.get_project_by_id(project_id)
	_make_project_active(project)

# -------------------------------------------------------------------------------------------------
func _on_project_closed(project_id: int) -> void:
	# Ask the user to save changes
	var project: CardProject = ProjectManager.get_project_by_id(project_id)
	if project.dirty:
		_unsaved_changes_dialog.project_ids.clear()
		_unsaved_changes_dialog.project_ids.append(project_id)
		_unsaved_changes_dialog.popup_centered()
	else:
		_close_project(project_id)

# -------------------------------------------------------------------------------------------------
func _close_project(project_id: int) -> void:
	var active_project: CardProject = ProjectManager.get_active_project()
	var project: CardProject = ProjectManager.get_project_by_id(project_id)
	var active_project_closed := active_project.id == project.id

	# Remove project
	ProjectManager.remove_project(project)
	_menubar.remove_tab(project)

	# Choose new project if active tab was closed
	if active_project_closed:
		if ProjectManager.get_project_count() == 0:
			_create_active_default_project()
		else:
			var new_project_id: int = _menubar.get_first_project_id()
			var new_project: CardProject = ProjectManager.get_project_by_id(new_project_id)
			_make_project_active(new_project)


# -------------------------------------------------------------------------------------------------
func _on_open_project(filepath: String) -> bool:
	# Check if file exists
	var file := File.new()
	if !file.file_exists(filepath):
		return false

	var project: CardProject = ProjectManager.get_open_project_by_filepath(filepath)
	var active_project: CardProject = ProjectManager.get_active_project()

	# Project already open. Just switch to tab
	if project != null:
		if project != active_project:
			_make_project_active(project)
		return true

	# Remove/Replace active project if not changed and unsaved (default project)
	if active_project.filepath.empty() && !active_project.dirty:
		ProjectManager.remove_project(active_project)
		_menubar.remove_tab(active_project)

	# Create and open it
	project = ProjectManager.add_project(filepath)
	_make_project_active(project)

	return true

# -------------------------------------------------------------------------------------------------
func _on_save_project_as() -> void:
	var active_project: CardProject = ProjectManager.get_active_project()
	_canvas.disable()
	_file_dialog.mode = FileDialog.MODE_SAVE_FILE
	_file_dialog.invalidate()
	_file_dialog.current_file = active_project.filepath.get_file()
	_file_dialog.connect("file_selected", self, "_on_file_selected_to_save_project")
	_file_dialog.connect("popup_hide", self, "_on_file_dialog_closed")
	_file_dialog.popup_centered()

# -------------------------------------------------------------------------------------------------
func _on_save_project() -> void:
	var active_project: CardProject = ProjectManager.get_active_project()
	if active_project.filepath.empty():
		_canvas.disable()
		_file_dialog.mode = FileDialog.MODE_SAVE_FILE
		_file_dialog.invalidate()
		_file_dialog.connect("file_selected", self, "_on_file_selected_to_save_project")
		_file_dialog.connect("popup_hide", self, "_on_file_dialog_closed")
		_file_dialog.popup_centered()
	else:
		_save_project(active_project)

# -------------------------------------------------------------------------------------------------
func _on_file_dialog_closed() -> void:
	_file_dialog.disconnect("file_selected", self, "_on_file_selected_to_save_project")
	_file_dialog.disconnect("popup_hide", self, "_on_file_dialog_closed")

# -------------------------------------------------------------------------------------------------
func _on_file_selected_to_save_project(filepath: String) -> void:
	var active_project: CardProject = ProjectManager.get_active_project()
	active_project.filepath = filepath
	_save_project(active_project)


# -------------------------------------------------------------------------------------------------
func _on_exit_with_changes_saved(project_ids: Array) -> void:
	if ProjectManager.has_unsaved_projects():
		_show_autosave_not_implemented_alert()
	else:
		ProjectManager.save_all_projects()
		get_tree().quit()
