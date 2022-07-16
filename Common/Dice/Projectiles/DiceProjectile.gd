# BaseDice
# ---------------------------------
extends BaseDice
class_name DiceProjectile


# Variables
# ------------------------------------------
export(float) var roll_time := 0.0
export(float) var destory_timer := 0.0

var move_speed := 0.0
var rotation_speed := 0.0

var move_dir := Vector2.ZERO
var velocity := Vector2.ZERO

onready var _roll_timer := $RollTimer


# Functions
# ----------------------------------------
func _ready() -> void:
	_roll_timer.wait_time = roll_time


func _physics_process(delta: float) -> void:
	velocity = move_dir * move_speed * delta
	self.global_position += velocity

	# self.rotation_degrees += rotation_speed * delta


func throw_dice(start_pos : Vector2, dir : Vector2, speed : float) -> void:
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
	destroy_dice()
