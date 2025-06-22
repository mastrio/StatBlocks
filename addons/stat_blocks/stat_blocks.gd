extends Node
## Autoload class for accessing stats.
##
## A class for accessing defined stats.
## These are set in the [b]Stats[/b] tab, found next to the [b]Game[/b] tab.
## Stat values can be accessed using the [method StatBlocks.get_stat] and [method StatBlocks.get_stat_as_int] methods.
## [br]
## This can be used to have easily editable stats for things such as the player's health and enemy damage.
## [br][br]
## [b]Usage:[/b]
## [codeblock lang=gdscript]
## @onready var stat: float = StatBlocks.get_stat("stat_block", "stat_id")
## [/codeblock]

## Dictionary containing every loaded stat block.
## Use [method StatBlocks.get_stat] and [method StatBlocks.get_stat_as_int] to access stats instead of using this dictionary directly.
## [br]
## This dictionary can also be modified at runtime to change stats, however doing so is not recommended and considered bad practice.
var stat_blocks: Dictionary


func _ready() -> void:
	# Load stat blocks
	if FileAccess.file_exists(ProjectSettings.get_setting("stat_blocks/path") + "stat_blocks.json"):
		var json_string: String = FileAccess.get_file_as_string(ProjectSettings.get_setting("stat_blocks/path") + "stat_blocks.json")
		var result = JSON.parse_string(json_string)
		if result != null: stat_blocks = result
	else: stat_blocks = {}

## Get a stat from a [param block] using an [param id].
## Returns [code]0.0[/code] if the stat does not exist.
func get_stat(block: String, id: String) -> float:
	if not stat_blocks.has(block): return 0.0
	if not stat_blocks.get(block).has(id): return 0.0
	
	return stat_blocks.get(block).get(id)

## Same as [method StatBlocks.get_stat] but returns the value as an [int] instead of a [float]
func get_stat_as_int(block: String, id: String) -> int:
	return int(get_stat(block, id))
