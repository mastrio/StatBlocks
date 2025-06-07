@tool
extends EditorPlugin


const STAT_EDITOR_SCENE: PackedScene = preload("res://addons/stat_blocks/stat_editor/stat_editor.tscn")

var stat_editor: Control


func _enter_tree() -> void:
	# Create Project Setting
	if !ProjectSettings.has_setting("stat_blocks/path"):
		ProjectSettings.set_setting("stat_blocks/path", "res://")
	
	# Create Editor GUI
	stat_editor = STAT_EDITOR_SCENE.instantiate()
	stat_editor.loaded_into_plugin = true
	EditorInterface.get_editor_main_screen().add_child(stat_editor)
	_make_visible(false)
	
	# Create Autoload
	add_autoload_singleton("StatBlocks", "res://addons/stat_blocks/stat_blocks.gd")

func _exit_tree() -> void:
	if stat_editor: stat_editor.queue_free()
	remove_autoload_singleton("StatBlocks")

func _save_external_data() -> void:
	stat_editor._save()

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	if stat_editor: stat_editor.visible = visible

func _get_plugin_name() -> String:
	return "Stats"

func _get_plugin_icon() -> Texture2D:
	return preload("res://addons/stat_blocks/stat_editor/icon.svg")
