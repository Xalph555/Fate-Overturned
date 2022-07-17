# UIManager
# -----------------------------------
extends CanvasLayer
class_name UIManager


# Variables
# -----------------------------------
export(NodePath) var player_hp_bar_path
export(NodePath) var level_up_ui_path
export(NodePath) var player_ui_path
export(NodePath) var game_over_ui_path



# Functions
# ----------------------------------------
func _ready() -> void:
	yield(get_tree(), "idle_frame")

	if player_hp_bar_path:
		var hp_bar = get_node(player_hp_bar_path)
		hp_bar.init_ui()
	
	if level_up_ui_path:
		var level_up_ui = get_node(level_up_ui_path)
		level_up_ui.init_ui()
	
	if player_ui_path:
		var player_ui = get_node(player_ui_path)
		player_ui.init_ui()
	
	if game_over_ui_path:
		var game_over_ui = get_node(game_over_ui_path)
		game_over_ui.init_ui()


