extends NonCombatEncounter

const SHOP_SCENE := preload("res://addons/cfc/src/dreamscape/Shop/Shop.tscn")
var current_shop


func _init():
	description = "<Shop Story Blurb goes here>"


func begin() -> void:
	globals.player.pathos.release(Terms.RUN_ACCUMULATION_NAMES.shop)
	.begin()
	current_shop = SHOP_SCENE.instance()
	cfc.get_tree().get_root().call_deferred("add_child", current_shop)
	yield(cfc.get_tree(),"idle_frame")
	current_shop.back_button.connect("pressed", self, "on_shop_back_pressed")


func on_shop_back_pressed() -> void:
	globals.journal.display_rewards('')
	current_shop.queue_free()
