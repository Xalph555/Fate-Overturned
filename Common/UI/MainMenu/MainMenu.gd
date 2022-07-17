# MainMenuUI
# -----------------------------------------------
extends Control
class_name MainMenuUI


# Variables
# ------------------------------------------
export(String, FILE) var game_scene 


# Functions
# ----------------------------------------
func _ready() -> void:
	get_tree().paused = false


func _on_Play_button_up() -> void:
	get_tree().change_scene(game_scene)
