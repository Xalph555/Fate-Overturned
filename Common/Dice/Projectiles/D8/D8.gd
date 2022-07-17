# D8 Projectile
# ---------------------------------
extends DiceProjectile


# Functions
# ----------------------------------------
func _on_HitBox_area_entered(area:Area2D) -> void:
	var hit_area = area as HurtBox

	if hit_area:
		var hit_object = hit_area.parent

		var knockback_dir = (hit_object.global_position - parent.global_position).normalized()

		hit_object.deal_damage(get_current_damage(), get_current_knockback(), knockback_dir, parent)
