tool
extends EditorPlugin

const tools = preload("res://addons/platformer_tools/tools/tools_mainscreen.tscn")
var tools_instance
var options := {}

func _enter_tree() -> void:
	add_autoload_singleton("GameManager", "res://addons/platformer_tools/classes/game_manager.gd")
	
	tools_instance = tools.instance()
	tools_instance.options = options# This is not using duplicate() function so the two variables are linked
	get_editor_interface().get_editor_viewport().add_child(tools_instance)
	tools_instance.get_node("Tools/Container/CustomLevelData/Update").icon = get_editor_interface().get_base_control().get_icon("Reload", "EditorIcons")
	make_visible(false)


func _exit_tree() -> void:
	remove_autoload_singleton("GameManager")
	
	if tools_instance:
		tools_instance.queue_free()


func has_main_screen() -> bool:
	return true


func make_visible(visible: bool) -> void:
	if tools_instance:
		tools_instance.visible = visible


func get_plugin_name() -> String:
	return "Platformer Tools"


func get_plugin_icon() -> Texture:
	return preload("res://addons/platformer_tools/tools/icon.svg")
