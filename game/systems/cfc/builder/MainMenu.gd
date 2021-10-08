extends PopupMenu
class_name MainMenu

# -------------------------------------------------------------------------------------------------
signal open_card_project(filepath)
signal save_card_project
signal save_card_project_as

# -------------------------------------------------------------------------------------------------
const ITEM_OPEN 		:= 0
const ITEM_SAVE 		:= 1
const ITEM_SAVE_AS 		:= 2


# -------------------------------------------------------------------------------------------------
export var file_dialog_path: NodePath
onready var _submenu_views: PopupMenu = $ViewsMenu
onready var _submenu_export: PopupMenu = $ExportMenu

# -------------------------------------------------------------------------------------------------
func _ready():
	# main menu
	add_item(tr("MENU_OPEN"), ITEM_OPEN)
	add_item(tr("MENU_SAVE"), ITEM_SAVE)
	add_item(tr("MENU_SAVE_AS"), ITEM_SAVE_AS)

# -------------------------------------------------------------------------------------------------
func _on_MainMenu_id_pressed(id: int):
	match id:
		ITEM_OPEN: _on_open_project()
		ITEM_SAVE: emit_signal("save_card_project")
		ITEM_SAVE_AS: emit_signal("save_card_project_as")


# -------------------------------------------------------------------------------------------------
func _on_open_project():
	var file_dialog: FileDialog = get_node(file_dialog_path)
	file_dialog.mode = FileDialog.MODE_OPEN_FILE
	file_dialog.connect("file_selected", self, "_on_project_selected_to_open")
	file_dialog.connect("popup_hide", self, "_on_file_dialog_closed")
	file_dialog.invalidate()
	file_dialog.popup_centered()

# -------------------------------------------------------------------------------------------------
func _on_project_selected_to_open(filepath: String) -> void:
	emit_signal("open_card_project", filepath)

# -------------------------------------------------------------------------------------------------
func _on_file_dialog_closed() -> void:
	var file_dialog: FileDialog = get_node(file_dialog_path)
	Utils.remove_signal_connections(file_dialog, "file_selected")
	Utils.remove_signal_connections(file_dialog, "popup_hide")


