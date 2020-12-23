extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var cur_rect_size = $"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer2/MarginContainer/主体画面定位容器".rect_size
	var cur_rect_global_position = $"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer2/MarginContainer/主体画面定位容器".rect_global_position
	
#	$"ViewportContainer".rect_size = cur_rect_size
#	$"ViewportContainer".rect_global_position = cur_rect_global_position
#	$"ViewportContainer/Viewport".size = cur_rect_size
	$"ViewportContainer/Viewport/主体画面".rect_size = cur_rect_size
	$"ViewportContainer/Viewport/主体画面".rect_global_position = cur_rect_global_position
