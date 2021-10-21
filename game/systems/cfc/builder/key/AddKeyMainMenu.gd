extends PopupMenu

# -------------------------------------------------------------------------------------------------
signal add_attr_ui
signal add_script_ui
signal add_trigger_ui

# -------------------------------------------------------------------------------------------------
const ITEM_ADD_ATTR 	:= 0
const ITEM_ADD_SCRIPT 	:= 1
const ITEM_ADD_TRIGGER 	:= 2


# -------------------------------------------------------------------------------------------------
func _ready():
	# main menu
	add_item(tr("MENU_ADD_ATTR"), ITEM_ADD_ATTR)
	add_item(tr("MENU_ADD_SCRIPT"), ITEM_ADD_SCRIPT)
	add_item(tr("MENU_ADD_TRIGGER"), ITEM_ADD_TRIGGER)

# -------------------------------------------------------------------------------------------------
func _on_MainMenu_id_pressed(id: int):
	match id:
		ITEM_ADD_ATTR: emit_signal("add_attr_ui")
		ITEM_ADD_SCRIPT: emit_signal("add_script_ui")
		ITEM_ADD_TRIGGER: emit_signal("add_trigger_ui")



