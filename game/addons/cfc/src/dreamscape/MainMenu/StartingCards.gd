extends ScrollContainer

const STARTING_CARD_PREVIEW_SCENE = preload("res://addons/cfc/src/dreamscape/MainMenu/StartingCardPreviewObject.tscn")

onready var _starting_cards_container = $HBC



func populate_starting_cards(types: Array, _rel_parent: Node) -> void:
	clear()
	for type in types:
		for archetype in Terms.CARD_GROUP_TERMS.values():
			if Aspects[archetype.to_upper()].has(type):
				for card_name in Aspects[archetype.to_upper()][type]["Starting Cards"]:
					var preview_card_object := STARTING_CARD_PREVIEW_SCENE.instance()
					_starting_cards_container.add_child(preview_card_object)
					preview_card_object.setup(card_name)	
	rect_min_size.y = CFConst.CARD_SIZE.y

func clear() -> void:
	for card in _starting_cards_container.get_children():
		card.queue_free()
	
