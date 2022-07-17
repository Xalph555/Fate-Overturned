# DiceCardUI
# -----------------------------------
extends TextureRect
class_name DiceCardUI


# Signals
# -----------------------------------
signal dice_card_selected(card)


# Variables
# -----------------------------------
export(NodePath) onready var dice_name_label = get_node(dice_name_label) as Label
export(NodePath) onready var dice_icon = get_node(dice_icon) as TextureRect
export(NodePath) onready var dice_description_label = get_node(dice_description_label) as Label

export(Texture) onready var normal_card
export(Texture) onready var highlighted_card

var dice : DiceResource


# Functions
# ----------------------------------------
func set_up_card(assigned_dice : DiceResource) -> void:
	dice = assigned_dice

	var dice_data = DiceDataBase.dice_data[assigned_dice.dice_data_name]

	dice_name_label.text = dice_data["name"]
	dice_icon.texture = assigned_dice.dice_icon
	dice_description_label.text = dice_data["description"]


func highlight_card(is_highlighted : bool) -> void:
	if is_highlighted:
		self.texture = highlighted_card
	
	else:
		self.texture = normal_card


func _on_DiceCard_gui_input(event:InputEvent) -> void:
	if event.is_action_pressed("action_1"):
		emit_signal("dice_card_selected", self)
