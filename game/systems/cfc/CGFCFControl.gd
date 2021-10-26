# Code for a sample playspace, you're expected to provide your own ;)
extends CFControl

# Returns a Dictionary with the combined Card definitions of all set files
func load_card_definitions() -> Dictionary:
	var set_definitions := CFUtils.list_files_in_directory(
				CFConst.PATH_SETS, CFConst.CARD_NAME_PREPEND)
	var combined_sets := {}
	for set_file in set_definitions:
		var data = Utils.load_json(CFConst.PATH_SETS + set_file)
		for dict_entry in data:
			var cur_data = data[dict_entry]["definition"]
			cur_data = Utils.transform_evalstring(cur_data)
			combined_sets[dict_entry] = cur_data
	return(combined_sets)


# Returns a Dictionary with the combined Script definitions of all set files
func load_script_definitions() -> Dictionary:
	var script_definitions := CFUtils.list_files_in_directory(
				CFConst.PATH_SETS, CFConst.CARD_NAME_PREPEND)
	var combined_scripts := {}
	for card_name in card_definitions.keys():
		for script_file in script_definitions:
			if combined_scripts.get(card_name):
				break
			var data = Utils.load_json(CFConst.PATH_SETS + script_file)
			# scripts are not defined as constants, as we want to be
			# able to refer specific variables inside them
			# such as cfc.deck etc. Instead they contain a
			# method which returns the script for the requested card name
			var card_script = data.get(card_name,{})
			if not card_script.empty():
				var cur_data = card_script["script"]
				cur_data = Utils.transform_evalstring(cur_data)
				combined_scripts[card_name] = cur_data
	return(combined_scripts)
