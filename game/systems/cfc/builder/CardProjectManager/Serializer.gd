class_name Serializer

const VERSION_NUMBER := 0

# -------------------------------------------------------------------------------------------------
static func save_card_project(project) -> void:
	var definition_data = project.meta_data.definition_dict
	var script_data = project.meta_data.script_dict
	var card_name = project.meta_data.card_name
	Utils.save_json({card_name:{"definition":definition_data,"script":script_data}},project.filepath)

# -------------------------------------------------------------------------------------------------
static func load_card_project(project) -> void:
	var data = Utils.load_json(project.filepath)
	var card_name = data.keys().front()
	data[card_name]["card_name"] = card_name # 额外数据
	project.meta_data = CardProjectMetadata.new(data[card_name])
		
