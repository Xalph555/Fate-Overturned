# GameEvents
# -----------------------------------------
extends Node


# Signals
# ----------------------------------
signal game_start

signal game_paused
signal game_resumed

signal player_died
signal player_level_up(new_level)

signal time_updated(new_time)