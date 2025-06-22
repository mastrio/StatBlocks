extends Control


@onready var player_health: int = StatBlocks.get_stat_as_int("player", "health")
@onready var player_strength: int = StatBlocks.get_stat_as_int("player", "strength")

@onready var enemy_health: float = StatBlocks.get_stat("basic_enemy", "health")
@onready var enemy_strength: float = StatBlocks.get_stat("basic_enemy", "strength")


func _process(_delta: float) -> void:
	%PlayerStats.text = "The Player has " + str(player_health) + " health and a strength of " + str(player_strength)
	%EnemyStats.text = "Basic Enemies have " + str(enemy_health) + " health and a strength of " + str(enemy_strength)
