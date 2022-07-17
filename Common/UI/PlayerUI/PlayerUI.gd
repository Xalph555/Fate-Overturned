# PlayerUI
# -----------------------------------
extends Control
class_name PlayerUI


# Variables
# -----------------------------------
export(NodePath) var exp_bar_path
export(NodePath) var time_counter_path
export(NodePath) var dice_indicator_path



# Functions
# ----------------------------------------
func init_ui() -> void:
	if exp_bar_path:
		var exp_bar = get_node(exp_bar_path)
		exp_bar.init_ui()
	
	if time_counter_path:
		var timer_counter = get_node(time_counter_path)
		timer_counter.init_ui()
	
	if dice_indicator_path:
		var dice_indicator = get_node(dice_indicator_path)
		dice_indicator.init_ui()