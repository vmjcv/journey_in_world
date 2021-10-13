class_name Serializer

const VERSION_NUMBER := 0

# -------------------------------------------------------------------------------------------------
static func save_card_project(project: CardProject) -> void:
	var definition_data = project.meta_data.make_definition_dict()
	var script_data = project.meta_data.make_script_dict()
	Utils.save_json({"definition":definition_data,"script":script_data},project.filepath)

# -------------------------------------------------------------------------------------------------
static func load_card_project(project: CardProject) -> void:
	var data = Utils.load_json(project.filepath)
	var cur_data = Utils.merge_dict(data["definition"],data["script"])
	match cur_data["card_type"]:
		"Rule":
			project.meta_data = RuleMetadata.new(cur_data)
		
