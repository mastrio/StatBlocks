@tool
extends HBoxContainer


signal value_update(value: float, block: String, stat: String)

var block_name: String
var stat_name: String

var selected: bool = false


func set_stat(block: String, name: String, value: float) -> void:
	%Name.text = name
	%Value.value = value
	
	block_name = block
	stat_name = name

func _on_value_changed(value: float) -> void:
	value_update.emit(value, block_name, stat_name)

func _on_selected_toggled(toggled_on: bool) -> void:
	selected = toggled_on
