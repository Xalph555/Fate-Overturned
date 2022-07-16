# Player Script
# -----------------------------------
extends KinematicBody2D
class_name Player

# Variables
# -----------------------------------
const TERMINAL_SPEED := 5000.0

export(float) var acceleration := 50.0
export(float) var max_speed := 500.0
export(float) var ground_friction := 0.2

onready var limit_speed := max_speed

var _input_dir := Vector2.ZERO
var velocity := Vector2.ZERO


# Functions
# ------------------------------------

func _physics_process(delta: float) -> void:
	velocity.x = clamp((velocity.x + _input_dir.x * acceleration), -limit_speed, limit_speed)
	velocity.y = clamp((velocity.y + _input_dir.y * acceleration), -limit_speed, limit_speed)

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
