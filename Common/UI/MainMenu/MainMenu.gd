# MainMenuUI
# -----------------------------------------------
extends Control
class_name MainMenuUI


# Variables
# ------------------------------------------
export(String, FILE) var game_scene 
export(AudioStream) var menu_music

export(NodePath) onready var main_node = get_node(main_node)
export(NodePath) onready var credits_node = get_node(credits_node)


# Functions
# ----------------------------------------
func _ready() -> void:
	get_tree().paused = false
	BackgroundMusicManager.change_track(menu_music)


func _on_Play_button_up() -> void:
	BackgroundMusicManager.fade_out()
	yield(BackgroundMusicManager, "music_stopped")
	get_tree().change_scene(game_scene)


func _on_Credits_button_up() -> void:
	main_node.visible = false
	credits_node.visible = true


func _on_Back_button_up() -> void:
	main_node.visible = true
	credits_node.visible = false