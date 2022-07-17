# EnemySpawner
# -----------------------------------------
extends Node2D
class_name EnemySpawner


# Variables
# ------------------------------------------
export (String, FILE, "*.json") var spawner_data_path

export(NodePath) onready var spawn_node = get_node(spawn_node) as YSort
var level_manager : LevelManager
var player_ref : Player

export(float) var spawn_distance := 1000.0

var time_thresholds := {}
var spawn_limits := {}
var spawn_rates := {}
var spawn_modifiers := {}

export(Array, PackedScene) var enemies := []

var spawn_level := 1
var time_to_next_level := 0.0

var total_spawned := 0
var current_spawn_limit := 0

onready var _spawn_timer := $SpawnTimer as Timer

# var rng = RandomNumberGenerator.new()


# Functions
# ----------------------------------------
func _ready() -> void:
	GameEvents.connect("game_start", self, "_on_game_start")

	level_manager = get_tree().get_nodes_in_group("LevelManager")[0]
	player_ref = get_tree().get_nodes_in_group("Player")[0]

	load_spawner_data()
	


func _process(_delta: float) -> void:
	if (level_manager.current_time >= time_to_next_level) and (spawn_level < time_thresholds.size()):

		spawn_level += 1

		time_to_next_level = time_thresholds[str(spawn_level)]
		current_spawn_limit = spawn_limits[str(spawn_level)]

		_spawn_timer.wait_time = spawn_rates[str(spawn_level)]

		print("Spawn Level Increased")


func load_spawner_data() -> void:
	var file = File.new()
	assert(file.file_exists(spawner_data_path))

	file.open(spawner_data_path, file.READ)
	var raw_data = parse_json(file.get_as_text())
	
	time_thresholds = raw_data["time_thresholds"]
	spawn_limits = raw_data["spawn_limits"]
	spawn_rates = raw_data["spawn_rates"]
	spawn_modifiers = raw_data["spawn_modifiers"]


func init_spawner() -> void:
	# rng.randomize()

	time_to_next_level = time_thresholds[str(spawn_level)]
	current_spawn_limit = spawn_limits[str(spawn_level)]

	_spawn_timer.wait_time = spawn_rates[str(spawn_level)]

	_spawn_timer.start()


func _on_SpawnTimer_timeout() -> void:
	if total_spawned >= current_spawn_limit:
		return

	var enemy_instance = enemies[0].instance()
	
	# var dir = Vector2.RIGHT.rotated(deg2rad(rng.randf_range(0, 360)))
	var dir = Vector2.RIGHT.rotated(deg2rad(rand_range(0, 360)))
	var spawn_pos = player_ref.global_position + (dir * spawn_distance)

	enemy_instance.spawn_init(player_ref, spawn_pos, spawn_modifiers[str(spawn_level)])
	enemy_instance.connect("enemy_died", self, "_on_enemy_death")

	spawn_node.add_child(enemy_instance)

	total_spawned += 1


func _on_enemy_death() -> void:
	total_spawned -= 1
	level_manager.total_kills += 1


func _on_game_start() -> void:
	init_spawner()