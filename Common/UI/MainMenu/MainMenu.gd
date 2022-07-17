# MainMenuUI
# -----------------------------------------------
extends Control
class_name MainMenuUI


# Variables
# ------------------------------------------
export(String, FILE) var game_scene 
export(AudioStream) var menu_music


# Functions
# ----------------------------------------
func _ready() -> void:
	get_tree().paused = false
	BackgroundMusicManager.change_track(menu_music)


func _on_Play_button_up() -> void:
	BackgroundMusicManager.fade_out()
	yield(BackgroundMusicManager, "music_stopped")
	get_tree().change_scene(game_scene)
