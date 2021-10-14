extends BaseInput

var init_key: String
var new_key: String
onready var Root: HBoxContainer = get_parent()


func _on_KeyName_text_changed(new_text: String) -> void:
	Root.name = new_text
	new_key = new_text


func _on_KeyName_text_entered(new_text: String) -> void:
	Root.name = new_text
	new_key = new_text

