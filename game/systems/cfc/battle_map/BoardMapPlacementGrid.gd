class_name BoardMapPlacementGrid
extends PanelContainer

# Used to add new BoardPlacementSlot instances to grids. We have to add the consts
# together before passing to the preload, or the parser complains
const _SLOT_SCENE_FILE = CFConst.PATH_CORE + "BoardPlacementSlot.tscn"
const _SLOT_SCENE = preload(_SLOT_SCENE_FILE)

# Set the highlight colour for all contained BoardPlacementSlot slots
export(Color) var highlight = CFConst.TARGET_HOVER_COLOUR
# If set to true, the grid will automatically add more slots
# when find_available_slot() is used and there's no more available slots
# (only useful when using the ScriptingEngine)
export var auto_extend := false

# Sets a custom label for this grid
onready var name_label = $Control/Label

func _ready() -> void:
	if not name_label.text:
		name_label.text = name


# If a BoardPlacementSlot object child in this container is highlighted
# Returns the object. Else returns null
func get_highlighted_slot() -> BoardPlacementSlot:
	var ret_slot: BoardPlacementSlot = null
	for slot in get_all_slots():
		if slot.is_highlighted():
			ret_slot = slot
	return(ret_slot)


# Returns the slot at the specified index.
func get_slot(idx: int) -> BoardPlacementSlot:
	var ret_slot: BoardPlacementSlot = $hex_map.get_child(idx)
	return(ret_slot)



# Returns a slot that is not currently occupied by a card
func find_available_slot() -> BoardPlacementSlot:
	var found_slot : BoardPlacementSlot
	if not get_available_slots().empty():
		found_slot = get_available_slots().front()
	return(found_slot)


# Returns an array containing all the BoardPlacementSlot nodes
func get_all_slots() -> Array:
	return($hex_map.get_children())


# Returns the amount of BoardPlacementSlot contained.
func get_slot_count() -> int:
	return(get_all_slots().size())


# Returns an array with all slots not occupied by a card
func get_available_slots() -> Array:
	var available_slots := []
	for slot in get_all_slots():
		if not slot.occupying_card:
			available_slots.append(slot)
	return(available_slots)


# Returns the count of all available slots
func count_available_slots() -> int:
	return(get_available_slots().size())
