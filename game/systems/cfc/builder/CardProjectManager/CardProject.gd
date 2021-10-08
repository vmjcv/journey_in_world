class_name CardProject

var id: int 

var dirty := false
var loaded := false

var filepath: String
var meta_data: CardProjectMetadata

# -------------------------------------------------------------------------------------------------
func _init():
	pass

# -------------------------------------------------------------------------------------------------
func clear() -> void:
	if meta_data:
		meta_data.clear()


func get_filename() -> String:
	if filepath.empty():
		return "Untitled"
	return filepath.get_file()

# -------------------------------------------------------------------------------------------------
func _to_string() -> String:
	return "%s: id: %d, loaded: %s, dirty: %s" % [filepath, id, loaded, dirty]
