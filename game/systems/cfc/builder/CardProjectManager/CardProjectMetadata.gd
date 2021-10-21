extends Reference
class_name CardProjectMetadata

var card_name
const CARD_NAME := "card_name"
var definition_dict
var script_dict

# -------------------------------------------------------------------------------------------------
func make_definition_dict() -> Dictionary:
	return 

func make_script_dict() -> Dictionary:
	return {
	}

# -------------------------------------------------------------------------------------------------
func apply_from_definition_dict(meta_data: Dictionary) -> void:
	definition_dict = meta_data

func apply_from_script_dict(meta_data: Dictionary) -> void:
	script_dict = meta_data

func _init(card_data):
	var definition = card_data["definition"]
	var script = card_data["script"]
	apply_from_definition_dict(definition)
	apply_from_script_dict(script)
	card_name = card_data["card_name"]

func clear():
	card_type = null
	card_name = null
	card_abilities = null
