extends Control

var color_group = preload("res://scene/common/color_group.tres")
var now_elevation = 0

func _ready():
	$VBoxContainer2/VBoxContainer/blue.group = color_group
	$VBoxContainer2/VBoxContainer/green.group = color_group
	$VBoxContainer2/VBoxContainer/white.group = color_group
	$VBoxContainer2/VBoxContainer/yellow.group = color_group


func get_now_color():
	var now_button = color_group.get_pressed_button()
	if now_button == $VBoxContainer2/VBoxContainer/blue:
		return "blue"
	elif now_button == $VBoxContainer2/VBoxContainer/green:
		return "green"
	elif now_button == $VBoxContainer2/VBoxContainer/white:
		return "white"
	elif now_button == $VBoxContainer2/VBoxContainer/yellow:
		return "yellow"
	return null


func _on_HSlider_value_changed(value):
	now_elevation = value
	$VBoxContainer2/VBoxContainer3/HBoxContainer/Label2.text = String(value)

func get_now_elevation():
	return now_elevation
