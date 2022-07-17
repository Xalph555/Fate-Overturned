# LevelUpUI
# -----------------------------------
extends Control
class_name LevelUpUI


# Variables
# -----------------------------------
export(NodePath) onready var card_container = get_node(card_container) as HBoxContainer
export(NodePath) onready var confirm_button = get_node(confirm_button) as Button

export(PackedScene) var dice_card

export(Array, Resource) var available_dice := []

var card_instances := []

var selected_card : DiceCardUI = null

var _player_ref : Player


# Functions
# ----------------------------------------
func init_ui() -> void:
	_player_ref = get_tree().get_nodes_in_group("Player")[0]

	GameEvents.connect("player_level_up", self, "_on_player_level_up")
	
	self.visible = false
	confirm_button.disabled = true


func set_up_ui() -> void:
	for _i in range(4):
		var rand_dice = randi() % available_dice.size()

		var card_instance = dice_card.instance()
		card_instance.connect("dice_card_selected", self, "_on_card_selected")
		card_container.add_child(card_instance)

		card_instance.set_up_card(available_dice[rand_dice])

		card_instances.append(card_instance)
	
	confirm_button.disabled = true


func clear_cards() -> void:
	for card in card_instances:
		card.disconnect("dice_card_selected", self, "_on_card_selected")
		card.call_deferred("free")
	
	card_instances.clear()


func close_ui() -> void:
	self.visible = false
	clear_cards()
	# GameEvents.emit_signal("resume_game")
	get_tree().get_nodes_in_group("LevelManager")[0].resume_game()


func _on_player_level_up(_new_level : int) -> void:
	# GameEvents.emit_signal("pause_game")

	get_tree().get_nodes_in_group("LevelManager")[0].pause_game()

	set_up_ui()
	self.visible = true


func _on_card_selected(card : DiceCardUI) -> void:
	for card_instance in card_instances:
		card_instance.highlight_card(false)
	
	card.highlight_card(true)
	selected_card = card

	confirm_button.disabled = false


func _on_ConfirmButton_button_up() -> void:
	if not selected_card:
		return
	
	_player_ref.dice_bag.add_dice(selected_card.dice)
	close_ui() 


func _on_SkipButton_button_up() -> void:
	close_ui() 
