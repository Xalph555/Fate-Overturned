# GameStartUI
# -----------------------------------
extends Button


func _on_SoundButton_button_down() -> void:
	$AudioStreamPlayer.play()
