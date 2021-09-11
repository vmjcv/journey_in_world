extends Popup

signal new_control

var new_event:InputEvent

func _ready()->void:
	popup_exclusive = true
	set_process_input(false)
	connect("about_to_show", self, "receive_input")
	

func receive_input()->void:
	set_process_input(true)


func _input(event)->void:
	if !event is InputEventKey && !event is InputEventJoypadButton && !event is InputEventJoypadMotion:
		return #only continue if one of those
	if !event.is_pressed():
		return
	new_event = event
	emit_signal("new_control")
	set_process_input(false)
	visible = false

func _notification(what):
	match what:
		NOTIFICATION_TRANSLATION_CHANGED:
			find_node("Message").text = tr("ADD_NEW_CONTROLS")
