# Level Manager
# -----------------------------------------------
extends Node2D
class_name LevelManager


# Signals
# -----------------------------------



# Variables
# ------------------------------------------
var current_time := 0.0
var counting_time := false


# Functions
# ----------------------------------------
func _ready() -> void:
	randomize()

	counting_time = true


func _process(delta: float) -> void:
	if counting_time:
		current_time += delta
		GameEvents.emit_signal("time_updated", current_time)


func pause_game() -> void:
	GameEvents.emit_signal("game_paused")
	get_tree().paused = true


func resume_game() -> void:
	GameEvents.emit_signal("game_resumed")
	get_tree().paused = false


