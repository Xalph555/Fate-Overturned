# NextDiceIndicatorUI
# -----------------------------------
extends VBoxContainer
class_name NextDiceIndicatorUI


# Variables
# -----------------------------------
export(NodePath) onready var dice_icon = get_node(dice_icon) as TextureRect


# Functions
# ----------------------------------------
func init_ui() -> void:
	get_tree().get_nodes_in_group("Player")[0].dice_bag.connect("new_current_dice", self, "_on_new_current_dice")


func _on_new_current_dice(new_dice : DiceResource) -> void:
	dice_icon.texture = new_dice.dice_icon
