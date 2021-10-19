extends Button

var index: String
onready var KeyScene: PackedScene = preload("uiKey.tscn")


func _ready() -> void:
	hint_tooltip = "Add Key"


func _on_uiAddKey_pressed() -> void:
	get_parent().add_one_key()
	raise()
