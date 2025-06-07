@tool
extends PanelContainer


const NEW_BLOCK_DIALOGUE: PackedScene = preload("res://addons/stat_blocks/stat_editor/new_block_dialogue.tscn")
const STAT: PackedScene = preload("res://addons/stat_blocks/stat_editor/stat.tscn")

var stat_blocks: Dictionary = {}
var loaded_into_plugin: bool = false
var selected_block: int = -1 : set = set_selected_block

var has_unsaved_changes: bool = false : set = set_has_unsaved_changes


func _ready() -> void:
	if loaded_into_plugin:
		_load_stat_blocks()
		_update_block_display()
		
		selected_block = -1
		has_unsaved_changes = false
		
		%NavBackground.set("theme_override_styles/panel", get_theme_stylebox("LaunchPadNormal", "EditorStyles"))
		%StatBlockListContainer.set("theme_override_styles/panel", get_theme_stylebox("TextureRegionPreviewBG", "EditorStyles"))
		%StatsContainer.set("theme_override_styles/panel", get_theme_stylebox("TextureRegionPreviewBG", "EditorStyles"))

func _load_stat_blocks() -> void:
	if FileAccess.file_exists(ProjectSettings.get_setting("stat_blocks/path") + "stat_blocks.json"):
		var json_string: String = FileAccess.get_file_as_string(ProjectSettings.get_setting("stat_blocks/path") + "stat_blocks.json")
		var result = JSON.parse_string(json_string)
		if result != null: stat_blocks = result
	else: stat_blocks = {}

func _update_block_display() -> void:
	%BlockDeleteButton.disabled = true
	selected_block = -1
	
	var counter: int = 0
	%BlockList.clear()
	for block: String in stat_blocks:
		%BlockList.add_item(block)
		counter += 1

func _update_stat_display() -> void:
	for child: HBoxContainer in %Stats.get_children(): child.queue_free()
	if selected_block == -1: return
	
	var selected_block_name: String = %BlockList.get_item_text(selected_block)
	var block_stats: Dictionary = stat_blocks.get(selected_block_name)
	for stat: String in block_stats:
		var stat_instance: HBoxContainer = STAT.instantiate()
		stat_instance.set_stat(selected_block_name, stat, block_stats.get(stat))
		stat_instance.value_update.connect(_on_stat_value_changed)
		%Stats.add_child(stat_instance)

func _save() -> void:
	var stat_file = FileAccess.open(ProjectSettings.get_setting("stat_blocks/path") + "stat_blocks.json", FileAccess.WRITE)
	stat_file.store_string(JSON.stringify(stat_blocks))
	stat_file.close()
	
	has_unsaved_changes = false

func set_selected_block(value: int) -> void:
	if value == -1: %StatButtons.hide()
	else: %StatButtons.show()
	
	selected_block = value

func set_has_unsaved_changes(value: bool) -> void:
	if value:
		%SaveButton.text = "    Save*    "
		%RevertButton.disabled = false
	else:
		%SaveButton.text = "    Save    "
		%RevertButton.disabled = true
	
	has_unsaved_changes = value

func _delete_block(block_name: String) -> void:
	stat_blocks.erase(block_name)
	has_unsaved_changes = true
	_update_block_display()
	_update_stat_display()

func _delete_stat(block_name: String, stat_name: String) -> void:
	stat_blocks.get(block_name).erase(stat_name)
	has_unsaved_changes = true
	_update_stat_display()

func _delete_selected_stats() -> void:
	for stat: HBoxContainer in %Stats.get_children():
		if stat.selected: _delete_stat(stat.block_name, stat.stat_name)

func _revert_blocks() -> void:
	has_unsaved_changes = false
	_load_stat_blocks()
	_update_block_display()
	_update_stat_display()

func _on_stat_value_changed(value: float, block: String, stat: String) -> void:
	has_unsaved_changes = true
	stat_blocks.get(block).set(stat, value)

func _on_save_button_pressed() -> void:
	_save()

func _on_revert_button_pressed() -> void:
	var confirm_window: ConfirmationDialog = ConfirmationDialog.new()
	confirm_window.size.y /= 2
	confirm_window.title = "Please Confirm..."
	confirm_window.dialog_text = "Revert unsaved changes?"
	confirm_window.confirmed.connect(_revert_blocks)
	confirm_window.position = (DisplayServer.window_get_size() / 2) - (confirm_window.size / 2)
	confirm_window.visible = true
	add_child(confirm_window)

func _on_refresh_button_pressed() -> void:
	_update_block_display()
	_update_stat_display()

func _on_new_block_button_pressed() -> void:
	var new_block_window: Window = NEW_BLOCK_DIALOGUE.instantiate()
	new_block_window.title = "Create New Stat Block"
	new_block_window.name_selected.connect(_new_block_name_selected)
	new_block_window.loaded_into_plugin = true
	add_child(new_block_window)

func _new_block_name_selected(name: String) -> void:
	# Make the new block
	stat_blocks.merge({name: {}})
	has_unsaved_changes = true;
	_update_block_display()

func _new_stat_name_selected(name: String) -> void:
	stat_blocks.get(%BlockList.get_item_text(selected_block)).merge({name: 0.0})
	has_unsaved_changes = true;
	_update_stat_display()

func _on_delete_block_button_pressed() -> void:
	var confirm_window: ConfirmationDialog = ConfirmationDialog.new()
	confirm_window.size.y /= 2
	confirm_window.title = "Please Confirm..."
	confirm_window.dialog_text = "Delete Block \"" + %BlockList.get_item_text(selected_block) + "\"?"
	confirm_window.confirmed.connect(_delete_block.bind(%BlockList.get_item_text(selected_block)))
	confirm_window.position = (DisplayServer.window_get_size() / 2) - (confirm_window.size / 2)
	confirm_window.visible = true
	add_child(confirm_window)

func _on_block_list_item_selected(index: int) -> void:
	selected_block = index
	%BlockDeleteButton.disabled = false
	_update_stat_display()

func _on_stat_new_button_pressed() -> void:
	var new_stat_window: Window = NEW_BLOCK_DIALOGUE.instantiate()
	new_stat_window.title = "Create New Stat"
	new_stat_window.name_selected.connect(_new_stat_name_selected)
	new_stat_window.loaded_into_plugin = true
	add_child(new_stat_window)

func _on_stat_delete_button_pressed() -> void:
	var confirm_window: ConfirmationDialog = ConfirmationDialog.new()
	confirm_window.size.y /= 2
	confirm_window.title = "Please Confirm..."
	confirm_window.dialog_text = "Delete Selected Stats?"
	confirm_window.confirmed.connect(_delete_selected_stats)
	confirm_window.position = (DisplayServer.window_get_size() / 2) - (confirm_window.size / 2)
	confirm_window.visible = true
	add_child(confirm_window)
