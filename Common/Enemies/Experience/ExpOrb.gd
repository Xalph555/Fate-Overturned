# ExpOrb
# -----------------------------------------
extends Area2D
class_name ExpOrb


# Variables
# ----------------------------------
var exp_amount := 0.0

var move_speed := 0.0

var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

var player_ref = null


# Functions
# ------------------------------------
func _physics_process(delta: float) -> void:
	if player_ref:
		move_dir = (player_ref.global_position - self.global_position).normalized()

		velocity = move_dir * move_speed * delta
		self.global_position += velocity


func set_movement(player, force : float) -> void:
	player_ref = player
	move_speed = force


func _on_ExpOrb_body_entered(body:Node) -> void:
	if player_ref == body:
		player_ref.player_stats.add_experience(exp_amount)
		call_deferred("free")

