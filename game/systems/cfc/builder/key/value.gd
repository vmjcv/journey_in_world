extends BaseInput

enum Type {_bool, _float, _String}
onready var Root: HBoxContainer = get_parent()


func convert_value(value: String):
	var key_name = Root.KeyNameField.text
	var result
	match Root.TypeSelectionBtn.selected:
		Type._String:
			result = value
		Type._bool:
			result = str2bool(value)
		Type._float:
			result = str2float(value)
	return result

func str2bool(value: String):
	var val = value.to_lower()
	if val == "false" or val == "0":
		return false
	elif val == "true" or val == "1":
		return true
	else:
		return null


func str2float(value: String):
	if value.is_valid_float():
		return float(value)
	else:
		return null
