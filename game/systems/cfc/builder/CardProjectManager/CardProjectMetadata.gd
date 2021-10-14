extends Reference
class_name CardProjectMetadata

var card_type
var card_name
var card_abilities
const CARD_TYPE := "Type"
const CARD_NAME := "card_name"
const CARD_ABILITIES := "card_abilities"

# -------------------------------------------------------------------------------------------------
func make_definition_dict() -> Dictionary:
	return {
		CARD_TYPE: card_type,
		CARD_NAME: card_name,
		CARD_ABILITIES: card_abilities,
	}

func make_script_dict() -> Dictionary:
	return {
	}

# -------------------------------------------------------------------------------------------------
func apply_from_dict(meta_data: Dictionary) -> void:
	card_type = meta_data[CARD_TYPE]
	card_name = meta_data[CARD_NAME]
	card_abilities = meta_data[CARD_ABILITIES]

func _init(meta_data):
	apply_from_dict(meta_data)

func clear():
	card_type = null
	card_name = null
	card_abilities = null
