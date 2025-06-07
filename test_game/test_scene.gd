extends Control


func _process(_delta: float) -> void:
	var player_health: int = StatBlocks.get_stat_as_int("player", "health")
	var player_strength: int = StatBlocks.get_stat_as_int("player", "strength")
	
	var enemy_health: float = StatBlocks.get_stat("basic_enemy", "health")
	var enemy_strength: float = StatBlocks.get_stat("basic_enemy", "strength")
	
	%PlayerStats.text = "The Player has " + str(player_health) + " health and a strength of " + str(player_strength)
	%EnemyStats.text = "Basic Enemies have " + str(enemy_health) + " health and a strength of " + str(enemy_strength)
