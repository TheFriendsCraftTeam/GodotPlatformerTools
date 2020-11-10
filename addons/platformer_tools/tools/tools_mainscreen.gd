tool
extends Control


const default_options := {
	"level_folder": "res://world/levels",
	"world_folder": "res://world/maps",
	"area_folder": "res://world/areas",
	"level_defaults": {"tile_size": Vector2(8, 8), "chunk_size": 256},
	}
var options := {}
var levels := {}
var active_lvl := ""


func _ready() -> void:
	$Tools/TopPanel/ToggleSidePanel.icon = get_icon("Forward", "EditorIcons")
	options = default_options.duplicate()# Load default options
	
	var options_file := File.new()
	if options_file.open("user://platformer_tools/settings.set", File.READ) == OK:
		var file_options = options_file.get_var(true)# Read options from the filesys
		if file_options is Dictionary:
			for key in file_options.keys():
				options[key] = file_options[key]# Instance every user modification
	
	options_file.close()
	update_levels()


func _on_settings_updated() -> void:
	var options_file := File.new()
	if options_file.open("user://platformer_tools/settings.set", File.WRITE) != OK:# Make the saving dir if it doesn't exist
		var dir := Directory.new()
		dir.make_dir("user://platformer_tools")
		options_file.open("user://platformer_tools/settings.set", File.WRITE)
	
	options_file.store_var(options, true)
	options_file.close()
	update_levels()


func update_levels():
	levels = GameManager.update_levels(options.level_folder)
	for tab in $Tools/CenterPanel/SidePanel/Levels/Container.get_children():
		if tab.name != "Lvl" and tab is VBoxContainer:
			tab.queue_free()
	
	for level in levels.keys():
		var lvl_tab := $Tools/CenterPanel/SidePanel/Levels/Container/Lvl.duplicate(0)# New node, without instancing
		lvl_tab.get_node("LabelContainer/Label").text = level.capitalize()
		(lvl_tab.get_node("EditAndAdd/Edit") as Button).connect("pressed", self, "_on_level_edit_requested", [level])
		(lvl_tab.get_node("EditAndAdd/AddNode") as Button).connect("pressed", self, "_on_level_add_requested", [level])
		(lvl_tab.get_node("RenameAndDelete/Rename") as Button).connect("pressed", self, "_on_level_rename_requested", [level])
		(lvl_tab.get_node("RenameAndDelete/Delete") as Button).connect("pressed", self, "_on_level_delete_requested", [level])
		lvl_tab.name = level
		$Tools/CenterPanel/SidePanel/Levels/Container.add_child(lvl_tab)
		lvl_tab.show()


func _on_level_created() -> void:
	if $NewLvl/Container/LvlName.text == "":
		$NewLvl/Container/Error.show()
		yield(get_tree().create_timer(5.0), "timeout")
		$NewLvl/Container/Error.hide()
		return
	GameManager.make_level($NewLvl/Container/LvlName.text, options)
	update_levels()
	$NewLvl.hide()


func delete_active_lvl() -> void:
	$DeleteLvl.hide()
	GameManager.delete_level(active_lvl, options)
	update_levels()


func _on_level_edit_requested(level):
	print("Edit requested: " + level)


func _on_level_add_requested(level):
	print("Node add requested: " + level)


func _on_level_rename_requested(level):
	print("Rename requested: " + level)


func _on_level_delete_requested(level):
	print("Delete requested: " + level)
	active_lvl = level
	$DeleteLvl.window_title = "DELETE %s??" % level.capitalize()# Make the string 4 the popup window's title
	$DeleteLvl.popup()


func _on_SidePanel_toggled(button_pressed: bool) -> void:
	$Tools/CenterPanel/SidePanel.visible = button_pressed


func _on_SizeBar_value_changed(value: float) -> void:
	for level in levels.keys():
		var lvl_thumbnail: TextureRect = get_node("Tools/CenterPanel/SidePanel/Levels/Container/" + level + "/Thumbnail")
		lvl_thumbnail.rect_min_size.y = value


func _on_MapEditor_connection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	$Tools/CenterPanel/Editors/MapEditor.connect_node(from, from_slot, to, to_slot)


func _on_MapEditor_disconnection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	$Tools/CenterPanel/Editors/MapEditor.disconnect_node(from, from_slot, to, to_slot)
