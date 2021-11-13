extends Card

# 先长后短


var outer_radius := 10 setget set_outer_radius,get_outer_radius# 外径大小
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

var _poly
var _poly_line
var _coll

signal hex_grid_selected

var highlighted = false
var unhoverColour = Color(Color.beige.r,Color.beige.g,Color.beige.b,0.1)

const grid_outer_radius = 30

var in_board_state

func _ready() -> void:

	pass

# Sample code on how to ensure costs are paid when a card
# is dragged from hand to the table
func common_move_scripts(new_container: Node, old_container: Node) -> void:
	if new_container == cfc.NMAP.board and old_container == cfc.NMAP.hand:
		pay_play_costs()


# Sample code on how to figure out costs of a card
func get_modified_credits_cost() -> int:
	var modified_cost : int = properties.get("Cost", 0)
	return(modified_cost)


# This sample function ensures all costs defined by a card are paid.
func pay_play_costs() -> void:
	cfc.NMAP.board.counters.mod_counter("credits", -get_modified_credits_cost())

# A signal for whenever the player clicks on a card
func _on_Card_gui_input(event) -> void:
	._on_Card_gui_input(event)
	if event is InputEventMouseButton:
		if event.is_pressed() and event.get_button_index() == 2:
			targeting_arrow.initiate_targeting()
		elif not event.is_pressed() and event.get_button_index() == 2:
			targeting_arrow.complete_targeting()

func _process_card_state() -> void:
	._process_card_state()
	if get_parent().is_in_group("hands"):
		set_board_state(false)
	elif get_parent() == cfc.NMAP.board:
		set_board_state(true)

func _determine_board_position_from_mouse() -> Vector2:
	var cur_drag_offset =_drag_offset
	if in_board_state:
		# 如果是在棋盘中则是另外的计算方式，以左上角为顶点
		cur_drag_offset -= Vector2(outer_radius,inner_radius)
	else:
		pass
	var targetpos: Vector2 = cfc.NMAP.board.mouse_pointer.determine_global_mouse_pos() - (cur_drag_offset * scale)
	if targetpos.x + card_size.x * scale.x >= get_viewport().size.x:
		targetpos.x = get_viewport().size.x - card_size.x * scale.x
	if targetpos.x < 0:
		targetpos.x = 0
	if targetpos.y + card_size.y * scale.y >= get_viewport().size.y:
		targetpos.y = get_viewport().size.y - card_size.y * scale.y
	if targetpos.y < 0:
		targetpos.y = 0
	return targetpos


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
	_poly.color = unhoverColour
	_coll.polygon = _corners
	_poly_line.points = _corners
	_poly_line.add_point(Vector2(-outer_radius,0))


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("hex_grid_selected")

func set_board_state(bVisible):
	if in_board_state != bVisible:
		in_board_state = bVisible
		_coll.disabled = not bVisible
		$Control2.visible = bVisible
		$Control.visible = not bVisible
		$CollisionShape2D.disabled = bVisible

func init_ui_var():
	_poly = $Control2/Polygon2D
	_poly_line = $Control2/Line2D
	_coll = $CollisionPolygon2D
	# 无法使用input_event事件监听整个拉动事件，原因是因为mouse_filter存在魔法，怀疑是某个控件或者容器吞噬了整个事件
	# 使用Control来监听事件，然后在方法回调中判断是否在区域内
	$Control2/Control.connect("gui_input", self, "_gui_input_board")


# 最开始的时候就设置碰撞体积的大小
func set_card_size(value: Vector2, ignore_area = false) -> void:
	.set_card_size(value,ignore_area)
	init_ui_var()
	set_outer_radius(grid_outer_radius)
	set_board_state(false)
	$Control2/Control.margin_left = -outer_radius
	$Control2/Control.margin_right = outer_radius
	$Control2/Control.margin_top = -inner_radius
	$Control2/Control.margin_bottom = inner_radius

func _gui_input_board(event):
	if cfc.NMAP.board.mouse_pointer in get_overlapping_areas():
		_on_Card_gui_input(event)
