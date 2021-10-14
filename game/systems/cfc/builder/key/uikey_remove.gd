extends Button

onready var Root: HBoxContainer = get_parent()

func _ready() -> void:
	hint_tooltip = "Remove Key"

func _on_Remove_pressed() -> void:
	Root.queue_free()
