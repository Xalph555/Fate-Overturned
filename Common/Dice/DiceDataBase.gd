# DiceDataBase
# ---------------------------------
extends Node


# Variables
# ------------------------------------------
export (String, FILE, "*.json") var dice_path
var dice_data : Dictionary


# Functions
# ----------------------------------------
func _ready() -> void:
	var file = File.new()
	assert(file.file_exists(dice_path))

	file.open(dice_path, file.READ)
	var raw_data = parse_json(file.get_as_text())
	dice_data = raw_data
