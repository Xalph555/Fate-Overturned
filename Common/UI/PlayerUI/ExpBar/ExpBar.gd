# ExpBarUI
# -----------------------------------
extends TextureProgress
class_name ExpBarUI


# Variables
# -----------------------------------
export(Resource) var player_stats

export(NodePath) onready var level_text = get_node(level_text) as Label

onready var _level_up_audio := $LevelUp


# Functions
# ------------------------------------
func init_ui() -> void:
	self.max_value = player_stats.max_experience
	self.value = 0.0
	level_text.text = "Lv: " + str(player_stats.current_level)

	player_stats.connect("all_stats_updated", self, "_on_all_stats_updated")
	player_stats.connect("current_level_updated", self, "_on_current_level_updated")
	player_stats.connect("max_experience_updated", self, "_on_max_experience_updated")
	player_stats.connect("current_experience_updated", self, "_on_current_experience_updated")


func _on_all_stats_updated() -> void:
	self.max_value = player_stats.max_experience
	self.value = 0.0
	level_text.text = "Lv: " +  str(player_stats.current_level)

func _on_current_level_updated(new_level : int) -> void:
	level_text.text = "Lv: " + str(new_level)
	_level_up_audio.playing = true

func _on_max_experience_updated(new_max_experience : float) -> void:
	self.max_value = new_max_experience

func _on_current_experience_updated(new_current_experience : float) -> void:
	self.value = new_current_experience
	