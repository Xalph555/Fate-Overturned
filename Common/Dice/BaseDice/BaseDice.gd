# BaseDice
# ---------------------------------
extends Sprite
class_name BaseDice


# Variables
# ------------------------------------------
export(String) var dice_name := ""

# dice_sides = {<side name : String> : <frame number : int>}
var _dice_sides := {}

var _base_weights := {}
var _weight_mods := {}
var _side_weights := {}
var _total_weight := 0.0

var _base_side_damage := {}
var _damage_mods := {}
var _side_damage := {}

var current_side := "1"


# Functions
# ----------------------------------------
func _ready() -> void:
	init_data()

	update_weights()
	update_damage()


func init_data() -> void:
	_dice_sides = DiceDataBase.dice_data[dice_name]["frames"]
	_base_weights = DiceDataBase.dice_data[dice_name]["weights"]
	_base_side_damage = DiceDataBase.dice_data[dice_name]["damage"]

	for side in _dice_sides:
		_weight_mods[side] = 0.0
		_side_weights[side] = 0.0

		_damage_mods[side] = 0.0
		_side_damage[side] = 0.0


func _process(_delta: float) -> void:
	update_side_sprite()


func update_side_sprite() -> void:
	self.frame = _dice_sides[current_side]


func update_weights() -> void:
	_total_weight = 0.0

	# setting accumualted weights
	for side in _base_weights:
		_total_weight += _base_weights[side] + _weight_mods[side]
		_side_weights[side] = _total_weight 


func update_damage() -> void:
	for side in _base_side_damage:
		_side_damage[side] = _base_side_damage[side] + _damage_mods[side]


func roll_dice() -> void:
	var roll := rand_range(0.0, _total_weight)

	for side in _side_weights:
		if _side_weights[side] > roll:
			current_side = side
			break


func get_current_damage() -> float:
	return _side_damage[current_side]
