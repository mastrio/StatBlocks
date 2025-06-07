extends Node


var stat_blocks: Dictionary


func _ready() -> void:
	# Load stat blocks
	if FileAccess.file_exists(ProjectSettings.get_setting("stat_blocks/path") + "stat_blocks.json"):
		var json_string: String = FileAccess.get_file_as_string(ProjectSettings.get_setting("stat_blocks/path") + "stat_blocks.json")
		var result = JSON.parse_string(json_string)
		if result != null: stat_blocks = result
	else: stat_blocks = {}

func get_stat(block: String, id: String) -> float:
	if not stat_blocks.has(block): return 0.0
	if not stat_blocks.get(block).has(id): return 0.0
	
	return stat_blocks.get(block).get(id)

func get_stat_as_int(block: String, id: String) -> int:
	return int(get_stat(block, id))
