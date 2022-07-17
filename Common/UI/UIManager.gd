# UIManager
# -----------------------------------
extends CanvasLayer
class_name UIManager


# Variables
# -----------------------------------
export(NodePath) var player_hp_bar
export(NodePath) var level_up_ui
export(NodePath) var player_ui



# Functions
# ----------------------------------------
func _ready() -> void:
	yield(get_tree(), "idle_frame")

	if player_hp_bar:
		var hp_bar = get_node(player_hp_bar)
		hp_bar.init_ui()
	
	if level_up_ui:
		var level_up = get_node(level_up_ui)
		level_up.init_ui()
	
	if player_ui:
		var p_ui = get_node(player_ui)
		p_ui.init_ui()


