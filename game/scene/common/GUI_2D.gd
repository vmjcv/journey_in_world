extends Control

var color_group = preload("res://scene/common/color_group.tres")


func _ready():
	$VBoxContainer/blue.group = color_group
	$VBoxContainer/green.group = color_group
	$VBoxContainer/white.group = color_group
	$VBoxContainer/yellow.group = color_group


func get_now_color():
	var now_button = color_group.get_pressed_button()
	if now_button == $VBoxContainer/blue:
		return "blue"
	elif now_button == $VBoxContainer/green:
		return "green"
	elif now_button == $VBoxContainer/white:
		return "white"
	elif now_button == $VBoxContainer/yellow:
		return "yellow"
	return null
