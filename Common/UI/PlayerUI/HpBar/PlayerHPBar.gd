# PlayerHPBarUI
# -----------------------------------
extends Control
class_name PlayerHPBarUI


# Variables
# -----------------------------------
# export(NodePath) onready var player = get_node(player) as Player
export(NodePath) onready var progress_bar = get_node(progress_bar) as TextureProgress

var _player_ref : Player


# Functions
# ------------------------------------
func init_ui(player_ref : Player) -> void:
	_player_ref = player_ref

	progress_bar.max_value = _player_ref.player_stats.max_health
	progress_bar.value = _player_ref.player_stats.current_health

	_player_ref.player_stats.connect("all_stats_updated", self, "_on_all_stats_updated")
	_player_ref.player_stats.connect("max_health_updated", self, "_on_max_health_updated")
	_player_ref.player_stats.connect("current_health_updated", self, "_on_current_health_updated")


func _process(delta: float) -> void:
	self.rect_position = _player_ref.get_global_transform_with_canvas().origin


func _on_all_stats_updated() -> void:
	progress_bar.max_value = _player_ref.player_stats.max_health
	progress_bar.value = _player_ref.player_stats.current_health

func _on_max_health_updated(new_max_health : float) -> void:
	progress_bar.max_value = new_max_health

func _on_current_health_updated(new_current_health : float) -> void:
	progress_bar.value = new_current_health