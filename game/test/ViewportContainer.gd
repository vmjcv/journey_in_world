extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Viewport/主体画面".rect_size = rect_size
	$"Viewport".size = rect_size



func _on_ViewportContainer_minimum_size_changed():
	$"Viewport/主体画面".rect_size = rect_size
	$"Viewport".size = rect_size
