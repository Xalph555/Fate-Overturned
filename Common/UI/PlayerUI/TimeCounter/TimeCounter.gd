# TimeCounterUI
# -----------------------------------
extends Label
class_name TimeCounterUI


# Functions
# ------------------------------------
func _ready() -> void:
	GameEvents.connect("time_updated", self, "_on_time_updated")


func _on_time_updated(new_time : float) -> void:
	var minutes := new_time / 60
	var seconds := fmod(new_time, 60)
	var milliseconds := fmod(new_time, 1) * 100
	
	self.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]