# HitBox
# -----------------------------------------
extends KinematicBody2D
class_name BasicEnemy

# Signals
# ----------------------------------
signal EnemyDied


# Variables
# ----------------------------------
# for testing
export(NodePath) onready var player_ref = get_node(player_ref) as Player

export(float) var max_health := 5.0
onready var current_health := max_health

export(float) var base_damage := 10.0
export(float) var base_knockback := 500.0

export(float) var move_speed := 30.0
export(float) var ground_friction := 0.2

var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

onready var _hurtbox := $HurtBox as HurtBox


# Functions
# ------------------------------------
func _ready() -> void:
	_hurtbox.parent = self


func _spawn_init(spawn_mod : float = 1.0) -> void:
	base_damage *= spawn_mod
	base_knockback *= spawn_mod
	move_speed *= spawn_mod


func _physics_process(delta: float) -> void:
	move_dir = (player_ref.global_position - self.global_position).normalized()

	velocity += move_dir * move_speed

	velocity.x = lerp(velocity.x, 0, ground_friction)
	velocity.y = lerp(velocity.y, 0, ground_friction)

	velocity = move_and_slide(velocity)


# damage
func deal_damage(dmg : float, knockback : float, knockback_dir : Vector2, damage_entity) -> void:
	current_health -= dmg

	var knockback_force = knockback_dir * knockback

	# print(velocity)
	# print(knockback_force)
	# print(velocity)

	velocity += knockback_force

	if current_health <= 0.0:
		emit_signal("EnemyDied")
		call_deferred("free")


func _on_HitBox_area_entered(area:Area2D) -> void:
	print("Basic enemy detecting possible hit")

	var hit_area = area as HurtBox

	if hit_area:
		var hit_object = hit_area.parent

		var knockback_dir = (hit_object.global_position - self.global_position).normalized()

		hit_object.deal_damage(base_damage, base_knockback, knockback_dir, self)

