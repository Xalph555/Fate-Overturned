# Player Stats 
# -----------------------------------
extends Resource
class_name PlayerStats


# Signals
# -----------------------------------
signal all_stats_updated

signal max_health_updated(new_max_health)
signal current_health_updated(new_current_health)

signal player_died

signal acceleration_updated(new_acceleration)
signal max_speed_updated(new_speed)

signal throw_force_updated(new_throw_force)
signal throw_rate_updated(new_throw_rate)

signal invincibility_time_updated(new_invincibility_time)

signal current_level_updated(new_level)
signal max_experience_updated(new_max_experience)
signal current_experience_updated(new_current_experience)


# Variables
# -----------------------------------
export(float) var max_health := 50.0
var current_health := 0.0

export(float) var acceleration := 70.0
export(float) var max_speed := 500.0

export(float) var throw_force := 500.0
export(float) var throw_rate := 0.7

export(float) var invincibility_time := 0.6

export(Array, float) var level_exp_thresholds
var current_level := 1
var max_experience := 0.0
var current_experience := 0.0


# Functions
# ------------------------------------
func init_stats() -> void:
	current_health = max_health
	max_experience = level_exp_thresholds[0]
	
	emit_signal("all_stats_updated")


# health
func add_max_health(amount : float) -> void:
	max_health += amount

	if max_health < 0.0:
		max_health = 0.0
	
	emit_signal("max_health_updated", max_health)


func add_current_health(amount : float) -> void:
	current_health += amount

	if current_health > max_health:
		current_health = max_health
	
	emit_signal("current_health_updated", current_health)

	if current_health <= 0.0:
		print("Player has died")
		emit_signal("player_died")


# movement
func add_acceleration(amount : float) -> void:
	acceleration += amount 

	if acceleration < 0.0:
		acceleration = 0.0

	emit_signal("acceleration_updated", acceleration)


func add_max_speed(amount : float) -> void:
	max_speed += amount

	if max_speed < 0.0:
		max_speed = 0.0

	emit_signal("max_speed_updated", max_speed)


# throw
func add_throw_force(amount : float) -> void:
	throw_force += amount

	if throw_force < 0.0:
		throw_force = 0.0
	
	emit_signal("throw_force_updated", throw_force)


func add_throw_rate(amount : float) -> void:
	throw_rate += amount

	if throw_rate <= 0.0:
		throw_rate = 0.001
	
	emit_signal("throw_rate_updated", throw_rate)


# invincibility
func add_invincibility_time(amount : float) -> void:
	invincibility_time += amount

	if invincibility_time <= 0.0:
		invincibility_time = 0.001

	emit_signal("invincibility_time_updated", invincibility_time)


# level
func add_experience(amount : float) -> void:
	current_experience += amount

	emit_signal("current_experience_updated", current_experience)

	while current_experience >= max_experience:
		current_experience -= max_experience
		emit_signal("current_experience_updated", current_experience)

		current_level += 1
		emit_signal("current_level_updated", current_level)

		if (current_level - 1) < level_exp_thresholds.size():
			max_experience = level_exp_thresholds[current_level]
			emit_signal("max_experience_updated", max_experience)


