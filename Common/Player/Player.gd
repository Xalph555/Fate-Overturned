# Player Script
# -----------------------------------
extends KinematicBody2D
class_name Player

# Variables
# -----------------------------------
const TERMINAL_SPEED := 5000.0

export(PackedScene) var temp_dice

export(float) var acceleration := 50.0
export(float) var max_speed := 500.0
export(float) var ground_friction := 0.2

onready var limit_speed := max_speed

var _input_dir := Vector2.ZERO
var velocity := Vector2.ZERO

export(float) var throw_force := 500.0
export(float) var throw_rate := 0.7

var _can_throw := true
var _is_throwing := false

var mouse_pos := Vector2.ZERO
var mouse_dir := Vector2.ZERO

onready var _throw_rate_timer := $ThrowRateTimer


# Functions
# ------------------------------------
func _ready() -> void:
	_throw_rate_timer.wait_time = throw_rate


func _process(_delta: float) -> void:
	if _can_throw and _is_throwing:
		throw_dice()


func _physics_process(_delta: float) -> void:
	update_mouse()

	var normalised_input = _input_dir.normalized()

	velocity.x = clamp((velocity.x + normalised_input.x * acceleration), -limit_speed, limit_speed)
	velocity.y = clamp((velocity.y + normalised_input.y * acceleration), -limit_speed, limit_speed)

	# max speed
	limit_speed = lerp(limit_speed, max_speed, 0.02)

	# friction
	velocity.x = lerp(velocity.x, 0, ground_friction)
	velocity.y = lerp(velocity.y, 0, ground_friction)

	# terminal speed
	velocity.x = clamp(velocity.x, -TERMINAL_SPEED, TERMINAL_SPEED)
	velocity.y = clamp(velocity.y, -TERMINAL_SPEED, TERMINAL_SPEED)

	velocity = move_and_slide(velocity)


func _unhandled_input(event: InputEvent) -> void:
	# movement
	if event.is_action_pressed("move_up"):
		_input_dir.y -= 1
	if event.is_action_released("move_up"):
		_input_dir.y += 1
	
	if event.is_action_pressed("move_down"):
		_input_dir.y += 1
	if event.is_action_released("move_down"):
		_input_dir.y -= 1
	
	if event.is_action_pressed("move_left"):
		_input_dir.x -= 1
	if event.is_action_released("move_left"):
		_input_dir.x += 1
	
	if event.is_action_pressed("move_right"):
		_input_dir.x += 1
	if event.is_action_released("move_right"):
		_input_dir.x -= 1

	# throw dice
	if event.is_action_pressed("action_1"):
		_is_throwing = true
	if event.is_action_released("action_1"):
		_is_throwing = false


func update_mouse() -> void:
	mouse_pos = get_global_mouse_position()
	mouse_dir = (mouse_pos - self.global_position).normalized()


func throw_dice() -> void:
	_can_throw = false

	var dice_instance = temp_dice.instance()
	get_tree().current_scene.add_child(dice_instance)

	dice_instance.throw_dice(self.global_position, mouse_dir, throw_force)

	_throw_rate_timer.start()


func _on_ThrowRateTimer_timeout() -> void:
	_can_throw = true