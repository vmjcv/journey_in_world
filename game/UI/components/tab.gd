extends PanelContainer
class_name Tab

# -------------------------------------------------------------------------------------------------
const STYLE_ACTIVE = preload("res://UI/themes/style_tab_active_dark.tres")
const STYLE_INACTIVE = preload("res://UI/themes/style_tab_inactive_dark.tres")

# -------------------------------------------------------------------------------------------------
signal selected
signal close_requested

# -------------------------------------------------------------------------------------------------
onready var _name_button: Button = $HBoxContainer/nameButton
onready var _close_button: TextureButton = $HBoxContainer/closeButton

var is_active := false
var title: String setget set_title
var id: int # 唯一id

# -------------------------------------------------------------------------------------------------
func _ready():
	set_active(false)
	_name_button.text = title

# -------------------------------------------------------------------------------------------------
func set_title(t: String) -> void:
	title = t
	if _name_button != null:
		_name_button.text = title

# -------------------------------------------------------------------------------------------------
func _on_nameButton_pressed():
	emit_signal("selected", self)

# -------------------------------------------------------------------------------------------------
func _on_closeButton_pressed():
	emit_signal("close_requested", self)

# -------------------------------------------------------------------------------------------------
func set_active(active: bool) -> void:
	is_active = active
	var new_style = STYLE_INACTIVE
	if is_active:
		new_style = STYLE_ACTIVE
	set("custom_styles/panel", new_style)

