# BaseDice
# ---------------------------------
extends BaseDice
class_name DiceProjectile


# Variables
# ------------------------------------------
export(float) var roll_time := 0.0
export(float) var destory_timer := 0.0


# damage
var _base_side_damage := {}
var _damage_mods := {}
var _side_damage := {}

# knock_back
var _base_side_knockback := {}
var _knockback_mods := {}
var _side_knockback := {}

var move_speed := 0.0
var rotation_speed := 0.0

var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

var parent

onready var _roll_timer := $RollTimer as Timer
onready var _hitbox := $HitBox as HitBox


# Functions
# ----------------------------------------
func _ready() -> void:
	_roll_timer.wait_time = roll_time


func init_data() -> void:
	.init_data()

	_base_side_damage = DiceDataBase.dice_data[dice_name]["damage"]
	_base_side_knockback = DiceDataBase.dice_data[dice_name]["knockback"]

	for side in _dice_sides:
		_damage_mods[side] = 0.0
		_side_damage[side] = 0.0

		_knockback_mods[side] = 0.0
		_side_knockback[side] = 0.0
	
	update_damage()
	update_knockback()


func _physics_process(delta: float) -> void:
	velocity = move_dir * move_speed * delta
	self.global_position += velocity

	# self.rotation_degrees += rotation_speed * delta


func update_damage() -> void:
	for side in _base_side_damage:
		_side_damage[side] = _base_side_damage[side] + _damage_mods[side]


func update_knockback() -> void:
	for side in _base_side_knockback:
		_side_knockback[side] = _base_side_knockback[side] + _knockback_mods[side]


func get_current_damage() -> float:
	return _side_damage[current_side]


func get_current_knockback() -> float:
	return _side_knockback[current_side]


func throw_dice(throw_parent, start_pos : Vector2, dir : Vector2, speed : float) -> void:
	parent = throw_parent
	_hitbox.parent = parent

	self.global_position = start_pos
	move_dir = dir

	move_speed = speed

	roll_dice()

	_roll_timer.start()


func destroy_dice() -> void:
	yield(get_tree().create_timer(destory_timer), "timeout")
	call_deferred("free")


func _on_RollTimer_timeout() -> void:
	move_dir = Vector2.ZERO
	_hitbox.disable_col_shape(true)
	
	destroy_dice()
