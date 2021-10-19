extends OptionButton

var init_index

var dirty setget ,get_dirty

func get_dirty():
	return init_index!=selected
