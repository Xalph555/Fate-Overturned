# BasicEnemy
# -----------------------------------------
extends KinematicBody2D
class_name BasicEnemy

# Signals
# ----------------------------------
signal enemy_died


# Variables
# ----------------------------------
export(PackedScene) var death_particles

export(PackedScene) var exp_orb
export(float) var base_exp := 10.0

export(float) var max_health := 5.0
onready var current_health := max_health

export(float) var base_damage := 10.0
export(float) var base_knockback := 500.0

export(float) var move_speed := 30.0
export(float) var ground_friction := 0.2

var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

var player_ref

onready var _hurtbox := $HurtBox as HurtBox

onready var _anim_player2 := $AnimationPlayer2
onready var _audio_player := $AudioStreamPlayer2D


# Functions
# ------------------------------------
func _ready() -> void:
	_hurtbox.parent = self


func spawn_init(player, location : Vector2, spawn_mod : float = 1.0) -> void:
	player_ref = player

	self.global_position = location

	max_health *= spawn_mod

	base_exp *= spawn_mod

	base_damage *= spawn_mod
	base_knockback *= spawn_mod
	move_speed *= spawn_mod


func _physics_process(delta: float) -> void:
	move_dir = (player_ref.global_position - self.global_position).normalized()

	velocity += move_dir * move_speed

	velocity.x = lerp(velocity.x, 0, ground_friction)
	velocity.y = lerp(velocity.y, 0, ground_friction)

	velocity = move_and_slide(velocity)

	update_sprite()

func update_sprite() -> void:
	if move_dir.x > 0:
		$Sprite.scale.x = -1
	
	if move_dir.x <= 0:
		$Sprite.scale.x = 1


func spawn_exp_orb() -> void:
	var exp_instance = exp_orb.instance()
	exp_instance.exp_amount = base_exp
	exp_instance.global_position = self.global_position
	get_tree().current_scene.add_child(exp_instance)


func spawn_death_particles() -> void:
	var particles_instance = death_particles.instance()
	particles_instance.global_position = self.global_position
	get_tree().current_scene.add_child(particles_instance)


# damage
func deal_damage(dmg : float, knockback : float, knockback_dir : Vector2, damage_entity) -> void:
	if current_health <= 0.0:
		return 

	current_health -= dmg

	var knockback_force = knockback_dir * knockback

	# print(velocity)
	# print(knockback_force)
	# print(velocity)

	velocity += knockback_force

	_anim_player2.play("Hurt")
	_audio_player.playing = true

	if current_health <= 0.0:
		call_deferred("spawn_exp_orb")
		call_deferred("spawn_death_particles")
		
		emit_signal("enemy_died")

		call_deferred("free")


func _on_HitBox_area_entered(area:Area2D) -> void:
	# print("Basic enemy detecting possible hit")

	var hit_area = area as HurtBox

	if hit_area:
		var hit_object = hit_area.parent

		var knockback_dir = (hit_object.global_position - self.global_position).normalized()

		hit_object.deal_damage(base_damage, base_knockback, knockback_dir, self)

