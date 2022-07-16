# HurtBox
# -----------------------------------------
extends Area2D
class_name HurtBox


# Variables
# ------------------------------------------
export(NodePath) onready var col_shape = get_node(col_shape)

var parent


# Functions
# ----------------------------------------
func disable_col_shape(is_disabled : bool) -> void:
	col_shape.set_deferred("disabled", is_disabled)