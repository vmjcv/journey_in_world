extends Artifact

# Overwritable function
func _on_artifact_added() -> void:
	globals.player.health += 10
