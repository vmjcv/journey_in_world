class_name BoardMapPlacementSlot
extends Area2D
# 先长后短
var outer_radius := 10.0 setget set_outer_radius,get_outer_radius# 外径大小
var inner_radius := outer_radius * 0.866025404 setget ,get_inner_radius# 内径大小
var _corners := PoolVector2Array([
	Vector2(-outer_radius,0),	
	Vector2(-outer_radius/2,inner_radius),	
	Vector2(outer_radius/2,inner_radius),	
	Vector2(outer_radius,0),	
	Vector2(outer_radius/2,-inner_radius),	
	Vector2(-outer_radius/2,-inner_radius),	
])

enum PointDirection {
	W,# 西
	SW,# 西南
	SE,# 东南
	E,# 东
	NE,# 东北
	NW,# 西北
}

enum SideDirection {
	SW,# 西南
	S,# 南
	SE,# 东南
	NE,# 东北
	N,# 北
	NW,# 西北
}

var hex_index
var row setget set_row# 行，y轴，从1开始
var column setget set_column# 列，x轴，从1开始
var sum setget ,get_sum# 总和值，即row+column
var x setget ,get_x
var y setget ,get_y

var index := 0

onready var _poly := $Polygon2D
onready var _poly_line := $Line2D
onready var _coll := $CollisionPolygon2D

signal hex_grid_selected


var occupying_card = null
var highlighted = false

onready var owner_grid = get_parent().get_parent()
#var _colors := PoolColorArray([Color.red,Color.blue,Color.yellow,Color.green,Color.gray,Color.wheat])

func set_outer_radius(_outer_radius):
	outer_radius = _outer_radius
	inner_radius = outer_radius * 0.866025404
	update_corners()

	
func get_outer_radius():
	return outer_radius
	
func get_inner_radius():
	return inner_radius

func get_point(direction):
	# 获得某个方向的点
	return _corners[direction]
	
func get_side(direction):
	# 获得某个方向的边
	return PoolVector2Array([_corners[direction],_corners[(direction+1)%6]])

func update_corners():
	_corners = PoolVector2Array([
		Vector2(-outer_radius,0),	
		Vector2(-outer_radius/2,inner_radius),	
		Vector2(outer_radius/2,inner_radius),	
		Vector2(outer_radius,0),	
		Vector2(outer_radius/2,-inner_radius),	
		Vector2(-outer_radius/2,-inner_radius),	
	])
	update_shape()
	

func update_shape():
	_poly.polygon = _corners
#	_poly.vertex_colors = _colors
	_poly.color = Color(0.002121, 0.956511, 0.632383, 0.05)
	_coll.polygon = _corners
	_poly_line.points = _corners
	_poly_line.add_point(Vector2(-outer_radius,0))

func _on_mouse_entered():
	_poly.color.a = 0.5
	highlighted = true

func _on_mouse_exited():
	_poly.color.a = 0.05
	highlighted = false

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("hex_grid_selected")

func get_sum():
	return -column-row

func _to_string():
	return "(columns:%d,rows:%d)"%[column, row]

func get_x():
	return (column - 1) * 1.5 * outer_radius

func get_y():
	return (row - 1 + (column-1)/2.0-floor((column-1)/2.0)) * 2 * inner_radius

func set_row(_row):
	row = _row
	update_position()

func set_column(_column):
	column = _column
	update_position()
	
func set_column_row(_column,_row):
	column = _column
	row = _row
	update_position()
	

func update_position():
	position = Vector2(get_x(),get_y())

func get_grid_name() -> String:
	return(owner_grid.name_label.text)


# Returns true if this slot is highlighted, else false
func is_highlighted() -> bool:
	return highlighted


# Changes card highlight colour.
func set_highlight(requested: bool,
		hoverColour = owner_grid.highlight) -> void:
	highlighted = requested
	if requested:
		_poly.color = hoverColour
	else:
		_poly.color.a = 0.05
	
