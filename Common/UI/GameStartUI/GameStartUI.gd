# GameStartUI
# -----------------------------------
extends Control
class_name GameStartUI


# Variables
# -----------------------------------
export(AudioStream) var level_music

onready var _anim_player := $AnimationPlayer


# Functions
# ----------------------------------------
func init_ui() -> void:
	self.visible = true
	_anim_player.play("StartAnimation")
	yield(_anim_player, "animation_finished")
	self.visible = false


func start_game() -> void:
	GameEvents.emit_signal("game_start")
	BackgroundMusicManager.change_track(level_music)