# Code for a sample playspace, you're expected to provide your own ;)
extends CFControl

# Returns a Dictionary with the combined Card definitions of all set files
func load_card_definitions() -> Dictionary:
	print("11111111111111")
	var set_definitions := CFUtils.list_files_in_directory(
				CFConst.PATH_SETS, CFConst.CARD_NAME_PREPEND)
	print(CFConst.PATH_SETS)
	print(CFConst.CARD_NAME_PREPEND)
	print(set_definitions)

	var combined_sets := {}
	for set_file in set_definitions:
		var data = Utils.load_json(CFConst.PATH_SETS + set_file)
		print(CFConst.PATH_SETS + set_file)
		print(data)
		for dict_entry in data:
			combined_sets[dict_entry] = data[dict_entry]["definition"]
	print(combined_sets)
	return(combined_sets)


# Returns a Dictionary with the combined Script definitions of all set files
func load_script_definitions() -> Dictionary:
	print("@222222222222")
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
			var card_script = data.get(card_name,null)
			if not card_script.empty():
				combined_scripts[card_name] = card_script["script"]
	print(combined_scripts)
	return(combined_scripts)
