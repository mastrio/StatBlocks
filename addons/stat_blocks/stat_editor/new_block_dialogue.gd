@tool
extends Window


signal name_selected(name: String)

var loaded_into_plugin: bool = false


func _ready() -> void:
	if loaded_into_plugin:
		%Background.set("theme_override_styles/panel", get_theme_stylebox("Content", "EditorStyles"))
		
		%NameInput.grab_focus()

func _process(_delta: float) -> void:
	if %NameInput.text == "": %CreateButton.disabled = true
	else: %CreateButton.disabled = false

func _on_create_button_pressed() -> void:
	name_selected.emit(%NameInput.text)
	queue_free()

func _on_cancel_button_pressed() -> void:
	queue_free()
