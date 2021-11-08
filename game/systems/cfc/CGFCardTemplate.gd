extends Card

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

onready var _poly := $Control2/Polygon2D
onready var _poly_line := $Control2/Line2D
onready var _coll := $CollisionPolygon2D

signal hex_grid_selected

var highlighted = false
var unhoverColour = Color.blue

const grid_outer_radius = 30

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
	match state:
		CardState.ON_PLAY_BOARD:
			set_outer_radius(grid_outer_radius)
			set_board_state(true)

		CardState.DROPPING_TO_BOARD:
			print("DROPPING_TO_BOARD")
			set_outer_radius(grid_outer_radius)
			set_board_state(true)

		CardState.FOCUSED_ON_BOARD:
			set_outer_radius(grid_outer_radius)
			set_board_state(true)
		_:
			set_board_state(false)


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
	_coll.visible = bVisible
	_coll.disabled = not bVisible
	$Control2.visible = bVisible
	$Control.visible = not bVisible
	$CollisionShape2D.visible = not bVisible
	$CollisionShape2D.disabled = bVisible
