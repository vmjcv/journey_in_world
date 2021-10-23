extends CVPreviewPopup

var properties
var scripts

func show_preview_card(card_name) -> void:
	if not is_instance_valid(preview_card):
		
		var template = load(CFConst.PATH_CARDS
		+ properties[CardConfig.SCENE_PROPERTY] + ".tscn")
		var card = template.instance()
		card.canonical_name = card_name
		card.properties = properties
		card.scripts = scripts
		card.state = card.CardState.VIEWPORT_FOCUS
		preview_card = card
		add_child(preview_card)
		preview_card.state = preview_card.CardState.PREVIEW
		# It's necessary we do this here because if we only we it during
		# the process, the card will appear to teleport
		if CFConst.VIEWPORT_FOCUS_ZOOM_TYPE == "resize":
			preview_card.resize_recursively(preview_card._control, CFConst.PREVIEW_SCALE)
			preview_card.card_front.scale_to(CFConst.PREVIEW_SCALE)
		rect_position = get_preview_placement()
		cfc.ov_utils.populate_info_panels(preview_card,focus_info)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = true
