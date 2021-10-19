class_name Serializer

const VERSION_NUMBER := 0

# -------------------------------------------------------------------------------------------------
static func save_card_project(project: CardProject) -> void:
	var definition_data = project.meta_data.make_definition_dict()
	var script_data = project.meta_data.make_script_dict()
	var card_name = project.meta_data.card_name
	Utils.save_json({card_name:{"definition":definition_data,"script":script_data}},project.filepath)

# -------------------------------------------------------------------------------------------------
static func load_card_project(project: CardProject) -> void:
	var data = Utils.load_json(project.filepath)
	var card_name = data.keys().front()
	var cur_data = Utils.merge_dict(data[card_name]["definition"],data[card_name]["script"])
	cur_data["card_name"] = card_name
	match cur_data["Type"]:
		"Rule":
			project.meta_data = RuleMetadata.new(cur_data)
		
