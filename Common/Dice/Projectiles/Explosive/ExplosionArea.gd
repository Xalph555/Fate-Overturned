# Explosion Area
# ---------------------------------
extends HitBox
class_name ExplosionArea


# Variables
# ------------------------------------------
var explosion_time := 0.3
var explosion_damage := 0.0
var explosion_knockback := 0.0

onready var _orange_particles := $Orange
onready var _greys_particles := $Greys
onready var _yellow_particles := $Yellow

onready var _explosion_timer := $ExplosionTimer


# Functions
# ----------------------------------------
func init_explosion() -> void:
	_orange_particles.lifetime = explosion_time
	_greys_particles.lifetime = explosion_time
	_yellow_particles.lifetime = explosion_time

	_explosion_timer.wait_time = explosion_time


func boom_boom(parent_ref, location : Vector2, damage : float, knockback : float) -> void:
	parent = parent_ref

	self.global_position = location
	explosion_damage = damage
	explosion_knockback = knockback

	emit_particles()
	_explosion_timer.start()

	yield(get_tree().create_timer(0.1), "timeout")
	var hurtboxes = get_overlapping_areas()

	for hurtbox in hurtboxes:
		var enemy = hurtbox as HurtBox

		if enemy:
			var distance = self.global_position.distance_to(enemy.parent.global_position)
			var t = clamp(inverse_lerp(col_shape.shape.radius, 15.0, distance), 0.0, 1.0)

			var current_dmg = lerp(0.0, explosion_damage, t)
			print("Damage dealth: ", current_dmg)
			var current_kb = lerp(0.0, explosion_knockback, t)

			var knockback_dir = (enemy.parent.global_position - self.global_position).normalized()

			enemy.parent.deal_damage(current_dmg, current_kb, knockback_dir, parent)


func emit_particles() -> void:
	_orange_particles.emitting = true
	_greys_particles.emitting = true
	_yellow_particles.emitting = true


func _on_ExplosionTimer_timeout() -> void:
	disable_col_shape(true)
	call_deferred("free")
