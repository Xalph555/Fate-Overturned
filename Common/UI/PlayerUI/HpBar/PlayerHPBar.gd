# PlayerHPBarUI
# -----------------------------------
extends Control
class_name PlayerHPBarUI


# Variables
# -----------------------------------
export(NodePath) onready var player = get_node(player) as Player
export(NodePath) onready var progress_bar = get_node(progress_bar) as TextureProgress


# Functions
# ------------------------------------
func _ready() -> void:
	progress_bar.max_value = player.player_stats.max_health
	progress_bar.value = player.player_stats.current_health

	player.player_stats.connect("all_stats_updated", self, "_on_all_stats_updated")
	player.player_stats.connect("max_health_updated", self, "_on_max_health_updated")
	player.player_stats.connect("current_health_updated", self, "_on_current_health_updated")


func _process(delta: float) -> void:
	self.rect_position = player.get_global_transform_with_canvas().origin


func _on_all_stats_updated() -> void:
	progress_bar.max_value = player.player_stats.max_health
	progress_bar.value = player.player_stats.current_health

func _on_max_health_updated(new_max_health : float) -> void:
	progress_bar.max_value = new_max_health

func _on_current_health_updated(new_current_health : float) -> void:
	progress_bar.value = new_current_health