# GameOverUI
# -----------------------------------------------
extends Control
class_name GameOverUI


# Variables
# ------------------------------------------
export(NodePath) onready var score_label = get_node(score_label) as Label

export(String, FILE) var main_menu_scene 
export(AudioStream) var game_over_music

var is_game_over := false


# Functions
# ----------------------------------------
func init_ui() -> void:
	GameEvents.connect("player_died", self, "_on_player_died")

	self.visible = false


func _on_player_died() -> void:
	if is_game_over: 
		return
	is_game_over = true

	BackgroundMusicManager.change_track(game_over_music)

	var level_manager = get_tree().get_nodes_in_group("LevelManager")[0]
	var player_stats = get_tree().get_nodes_in_group("Player")[0].player_stats

	level_manager.game_over()
	self.visible = true


	var score = level_manager.current_time * 100 + level_manager.total_kills * 50 + player_stats.current_level * 15

	score_label.text = "Score: " + str(int(score))


func _on_PlayAgain_button_up() -> void:
	get_tree().reload_current_scene()


func _on_MainMenu_button_up() -> void:
	get_tree().change_scene(main_menu_scene)

