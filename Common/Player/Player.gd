# Player Script
# -----------------------------------
extends KinematicBody2D
class_name Player


# Variables
# -----------------------------------
const TERMINAL_SPEED := 5000.0

export(AudioStream) var hurt_sound

export(Resource) var player_stats

# export(float) var acceleration := 70.0
# export(float) var max_speed := 500.0
export(float) var ground_friction := 0.2

onready var limit_speed := 0.0

var _input_dir := Vector2.ZERO
var velocity := Vector2.ZERO

# export(float) var throw_force := 500.0
# export(float) var throw_rate := 0.7

var _can_throw := true
var _is_throwing := false

var mouse_pos := Vector2.ZERO
var mouse_dir := Vector2.ZERO

onready var dice_bag := $DiceBag as DiceBag

onready var _throw_rate_timer := $ThrowRateTimer as Timer
onready var _invincibility_timer := $invincibilityTimer as Timer

onready var _hurtbox := $HurtBox as HurtBox

onready var _sprite := $Sprite
onready var _anim_player := $AnimationPlayer
onready var _anim_player2 := $AnimationPlayer2

onready var _audio_player := $AudioStreamPlayer


# Functions
# ------------------------------------
func _ready() -> void:
	_hurtbox.parent = self
	dice_bag.player = self

	_init_stats()


func _init_stats() -> void:
	player_stats.init_stats()

	player_stats.connect("throw_rate_updated", self, "_on_throw_rate_updated")
	player_stats.connect("invincibility_time_updated", self, "_on_invincibility_time_updated")

	_throw_rate_timer.wait_time = player_stats.throw_rate
	_invincibility_timer.wait_time = player_stats.invincibility_time
	

func _process(_delta: float) -> void:
	update_sprite()

	if _can_throw and _is_throwing:
		_can_throw = false

		dice_bag.throw_dice()

		_throw_rate_timer.start()


func _physics_process(_delta: float) -> void:
	update_mouse()

	var normalised_input = _input_dir.normalized()

	# velocity.x = clamp((velocity.x + normalised_input.x * acceleration), -limit_speed, limit_speed)
	# velocity.y = clamp((velocity.y + normalised_input.y * acceleration), -limit_speed, limit_speed)

	# # velocity = (velocity + normalised_input * acceleration).clamped(limit_speed)

	velocity += normalised_input * player_stats.acceleration

	# max speed
	limit_speed = lerp(limit_speed, player_stats.max_speed, 0.02)

	# friction
	velocity.x = lerp(velocity.x, 0, ground_friction)
	velocity.y = lerp(velocity.y, 0, ground_friction)

	# terminal speed
	velocity.x = clamp(velocity.x, -TERMINAL_SPEED, TERMINAL_SPEED)
	velocity.y = clamp(velocity.y, -TERMINAL_SPEED, TERMINAL_SPEED)

	velocity = move_and_slide(velocity)


func _unhandled_input(event: InputEvent) -> void:
	# movement
	# if event.is_action_pressed("move_up"):
	# 	_input_dir.y -= 1
	# if event.is_action_released("move_up"):
	# 	_input_dir.y += 1
	
	# if event.is_action_pressed("move_down"):
	# 	_input_dir.y += 1
	# if event.is_action_released("move_down"):
	# 	_input_dir.y -= 1
	
	# if event.is_action_pressed("move_left"):
	# 	_input_dir.x -= 1
	# if event.is_action_released("move_left"):
	# 	_input_dir.x += 1
	
	# if event.is_action_pressed("move_right"):
	# 	_input_dir.x += 1
	# if event.is_action_released("move_right"):
	# 	_input_dir.x -= 1
	
	_input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# throw dice
	if event.is_action_pressed("action_1"):
		_is_throwing = true
	if event.is_action_released("action_1"):
		_is_throwing = false


func update_mouse() -> void:
	mouse_pos = get_global_mouse_position()
	mouse_dir = (mouse_pos - self.global_position).normalized()


func update_sprite() -> void:
	if velocity.length() > 10.0:
		_anim_player.play("Walk")
	
	else:
		_anim_player.play("Idle")
	
	if _input_dir.x > 0:
		_sprite.scale.x = -1
	
	if _input_dir.x < 0:
		_sprite.scale.x = 1


# func throw_dice() -> void:
# 	_can_throw = false

# 	var dice_instance = temp_dice.instance()
# 	get_tree().current_scene.add_child(dice_instance)

# 	dice_instance.throw_dice(self, self.global_position, mouse_dir, player_stats.throw_force)

# 	_throw_rate_timer.start()


# damage
func deal_damage(dmg : float, knockback : float, knockback_dir : Vector2, damage_entity) -> void:
	print("player was hit, Damage: ", dmg)

	# print("current health: ", player_stats.current_health)

	player_stats.add_current_health(-dmg)

	var knockback_force = knockback_dir * knockback
	velocity += knockback_force

	_hurtbox.disable_col_shape(true)
	_invincibility_timer.start()
	_anim_player2.play("Hurt")
	
	_audio_player.stream = hurt_sound
	_audio_player.playing = true


func _on_ThrowRateTimer_timeout() -> void:
	_can_throw = true

func _on_invincibilityTimer_timeout() -> void:
	_hurtbox.disable_col_shape(false)
	_anim_player2.stop()
	_sprite.visible = true

func _on_throw_rate_updated(new_throw_rate : float) -> void:
	_throw_rate_timer.wait_time = new_throw_rate

func _on_invincibility_time_updated(new_invincibility_time : float) -> void:
	_invincibility_timer.wait_time = new_invincibility_time


# exp collection
func _on_ExpCollectionArea_area_entered(area:Area2D) -> void:
	var exp_orb = area as ExpOrb

	if exp_orb:
		exp_orb.set_movement(self, player_stats.exp_pull_force)

func _on_ExpCollectionArea_area_exited(area:Area2D) -> void:
	var exp_orb = area as ExpOrb

	if exp_orb:
		exp_orb.set_movement(null, 0.0)
