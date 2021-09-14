extends Node


func main(value: Dictionary) -> void:
	var cur_value = value["value"]
	var cur_local = Utils.get_language_from_resolution_enum(int(value["value"]))
	TranslationServer.set_locale(cur_local)
