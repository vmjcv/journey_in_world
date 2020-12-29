extends Control

func _ready():
	var cur_rect_size = $"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer2/MarginContainer/主体画面定位容器".rect_size
	var cur_rect_global_position = $"ViewportContainer2/Viewport/VBoxContainer/HBoxContainer2/MarginContainer/主体画面定位容器".rect_global_position
	$"ViewportContainer/Viewport/主体画面".rect_size = cur_rect_size
	$"ViewportContainer/Viewport/主体画面".rect_global_position = cur_rect_global_position
