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

onready var _col_shape := $CollisionShape2D
onready var _sprite := $Sprite
onready var _audio_player := $AudioStreamPlayer2D


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


func hide() -> void:
	_col_shape.disabled = true
	_sprite.visible = false


func _on_ExpOrb_body_entered(body:Node) -> void:
	if player_ref == body:
		call_deferred("hide")

		player_ref.player_stats.add_experience(exp_amount)

		_audio_player.playing = true
		yield(get_tree().create_timer(0.8), "timeout")

		call_deferred("free")

