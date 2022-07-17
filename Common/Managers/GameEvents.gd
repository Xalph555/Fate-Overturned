# GameEvents
# -----------------------------------------
extends Node


# Signals
# ----------------------------------
signal pause_game
signal resume_game

signal player_died
signal player_level_up(new_level)

signal time_updated(new_time)