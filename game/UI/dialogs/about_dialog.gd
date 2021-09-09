extends WindowDialog

# -------------------------------------------------------------------------------------------------
onready var _version_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/VersionLabel

# -------------------------------------------------------------------------------------------------
func _ready():
	_version_label.text = "%s v%s" % [tr("GAME_TITLE"),Config.VERSION_STRING]

# -------------------------------------------------------------------------------------------------
func _on_GithubLinkButton_pressed():
	
	OS.shell_open("https://github.com/vmjcv/journey_in_world")

# -------------------------------------------------------------------------------------------------
func _on_LicenseButton_pressed():
	OS.shell_open("https://github.com/vmjcv/journey_in_world/LICENSE")

# -------------------------------------------------------------------------------------------------
func _on_GodotButton_pressed():
	OS.shell_open("https://godotengine.org/")

# -------------------------------------------------------------------------------------------------
func _on_KennyButton_pressed():
	OS.shell_open("https://www.kenney.nl/assets/platformer-art-deluxe")
