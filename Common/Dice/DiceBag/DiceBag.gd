# DiceBag
# -----------------------------------
extends Node2D
class_name DiceBag


# Signals
# -----------------------------------
signal new_current_dice(dice)


# Variables
# -----------------------------------
export(Array, Resource) var dice := []
var next_dice := 0

var player

onready var _audio_player := $AudioStreamPlayer


# Functions
# ------------------------------------
func throw_dice() -> void:
	var dice_instance = dice[next_dice].dice_scene.instance()
	get_tree().current_scene.add_child(dice_instance)

	dice_instance.throw_dice(player, player.global_position, player.mouse_dir, player.player_stats.throw_force)
	_audio_player.playing = true

	next_dice += 1

	if next_dice >= dice.size():
		dice.shuffle()
		next_dice = 0
	
	emit_signal("new_current_dice", dice[next_dice])


func add_dice(new_dice : DiceResource) -> void:
	if new_dice:
		dice.append(new_dice)