# ExplosiveDice Projectile
# ---------------------------------
extends DiceProjectile


# Variables
# -----------------------------------
export(PackedScene) var explosion_area
# export(float) var explosion_radius := 80.0
export(float) var explosion_damage := 15.0
export(float) var explosion_knockback := 1000.0

var explosion_interval := 0.4
var total_explosions := 0

onready var _explosion_timer := $ExplosionTimer


# Functions
# ----------------------------------------
func _ready() -> void:
	._ready()

	_explosion_timer.wait_time = explosion_interval


func destroy_dice() -> void:
	_explosion_timer.start()


func _on_ExplosionTimer_timeout() -> void:
	var explosion_instance = explosion_area.instance()
	get_tree().current_scene.add_child(explosion_instance)
	explosion_instance.boom_boom(parent, self.global_position, explosion_damage, explosion_knockback)

	total_explosions += 1

	if total_explosions < int(current_side):
		_explosion_timer.start()
	
	else:
		call_deferred("free")


func _on_HitBox_area_entered(area:Area2D) -> void:
	var hit_area = area as HurtBox

	if hit_area:
		var hit_object = hit_area.parent

		var knockback_dir = (hit_object.global_position - parent.global_position).normalized()

		hit_object.deal_damage(get_current_damage(), get_current_knockback(), knockback_dir, parent)
