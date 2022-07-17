# AimIndicator
# -----------------------------------
extends Control
class_name AimIndicator


# Variables
# -----------------------------------
var _player : Player


# Functions
# ------------------------------------
func init_ui() -> void:
	_player = get_tree().get_nodes_in_group("Player")[0]


func _process(delta: float) -> void:
	self.rect_position = _player.get_global_transform_with_canvas().origin
	self.set_rotation((get_global_mouse_position() - self.rect_global_position).angle())
