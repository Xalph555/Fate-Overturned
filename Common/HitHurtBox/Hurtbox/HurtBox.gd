# HurtBox
# -----------------------------------------
extends Area2D
class_name HurtBox


# Variables
# ------------------------------------------
export(NodePath) onready var col_shape = get_node(col_shape)


# Functions
# ----------------------------------------
func disable_col_shape(is_disabled : bool) -> void:
	col_shape.disabled = is_disabled