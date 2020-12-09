tool
extends Control


const DEFAULT_OPTIONS := {
	"level_folder": "res://world/levels",
	"world_folder": "res://world/maps",
	"area_folder": "res://world/areas",
	"level_defaults": {"tile_size": Vector2(8, 8), "chunk_size": 256},
}
var options := {}
var levels := {}
var active_lvl := ""
var level_nodes := {}


func _ready() -> void:
	$Tools/TopPanel/ToggleSidePanel.icon = get_icon("Forward", "EditorIcons")# Set an icon from the editor theme to a button
	#$Tools/CenterPanel/SidePanel/Levels/Levels/Container/Lvl/Thumbnail/Change.icon = get_icon("Folder", "EditorIcons")
	options = DEFAULT_OPTIONS.duplicate()# Load default options

	var options_file := File.new()
	if options_file.open("user://platformer_tools/settings.set", File.READ) == OK:
		var file_options = options_file.get_var(true)# Read options from the filesys
		if file_options is Dictionary:
			for key in file_options.keys():
				options[key] = file_options[key]# Instance every user modification

	options_file.close()
	update_levels()# Update Levels on startup


func _on_settings_updated() -> void:# Saves the options to a file (settings.set)
	var options_file := File.new()
	if options_file.open("user://platformer_tools/settings.set", File.WRITE) != OK:# Make the saving dir if it doesn't exist
		var dir := Directory.new()
		dir.make_dir("user://platformer_tools")
		options_file.open("user://platformer_tools/settings.set", File.WRITE)

	options_file.store_var(options, true)
	options_file.close()
	update_levels()


func update_levels():
	levels = GameManager.update_levels()
	for tab in $Tools/CenterPanel/SidePanel/Levels/Levels/Container.get_children():
		if tab.name != "Lvl" and tab is VBoxContainer:
			tab.queue_free()

	for level in levels.keys():
		var lvl_tab := $Tools/CenterPanel/SidePanel/Levels/Levels/Container/Lvl.duplicate(0)# New node, without instancing
		lvl_tab.get_node("LabelContainer/Label").text = level.capitalize()
		(lvl_tab.get_node("EditAndAdd/Edit") as Button).connect("pressed", self, "_on_level_edit_requested", [level])
		(lvl_tab.get_node("EditAndAdd/AddNode") as Button).connect("pressed", self, "_on_level_add_requested", [level])
		(lvl_tab.get_node("RenameAndDelete/Rename") as Button).connect("pressed", self, "_on_level_rename_requested", [level])
		(lvl_tab.get_node("RenameAndDelete/Delete") as Button).connect("pressed", self, "_on_level_delete_requested", [level])
		lvl_tab.name = level
		$Tools/CenterPanel/SidePanel/Levels/Levels/Container.add_child(lvl_tab)
		lvl_tab.show()


func _on_level_created() -> void:
	update_levels()
	var err: int = GameManager.make_level($NewLvl/Container/LvlName.text)
	update_levels()
	if err:
		match err:
			FAILED:
				$NewLvl/Container/Error.bbcode_text = "[color=red]Wooza! Seems like we got a general error, watch the console to know more..."
			ERR_INVALID_PARAMETER:
				$NewLvl/Container/Error.bbcode_text = "[color=red]Ehm, you should insert a name for the Level..."
			ERR_ALREADY_EXISTS:
				$NewLvl/Container/Error.bbcode_text = "[color=red]Whops, seems like the Level mentioned here already exists..."
			var id:
				$NewLvl/Container/Error.bbcode_text = "[color=red]... Seems like we were not prepared for this type of error: " + String(id) + ". You should check out the docs."
		$NewLvl/Container/Error.show()
		yield(get_tree().create_timer(4.0), "timeout")
		$NewLvl/Container/Error.hide()
		return
	$NewLvl.hide()


func delete_active_lvl() -> void:
	if GameManager.delete_level(active_lvl):
		$DeleteLvl/Container/Error.show()
		yield(get_tree().create_timer(4.0), "timeout")
		$DeleteLvl/Container/Error.hide()
		return# Something went wrong
	$DeleteLvl.hide()

	print("Level deleted, deleting nodes...")
	print(level_nodes[active_lvl].size())

	for node_id in level_nodes[active_lvl].size():
		print("Node Id: " + String(node_id))
		print(level_nodes[active_lvl][0].name)
		_on_delete_node_request(level_nodes[active_lvl][0], active_lvl)
	level_nodes.erase(active_lvl)

	print("Updating...")
	update_levels()
	print("Done!")


func rename_active_lvl() -> void:# TODO: Fix bugs (rename to an existing lvl)
	var new_id = $RenameLvl/Container/LvlName.text

	update_levels()
	var err: int = GameManager.rename_level(active_lvl, new_id)
	update_levels()
	if err:
		match err:
			FAILED:
				$RenameLvl/Container/Error.bbcode_text = "[color=red]Wooza! Seems like we got a general error, watch the console to know more..."
			ERR_INVALID_PARAMETER:
				$RenameLvl/Container/Error.bbcode_text = "[color=red]Ehm, you should insert a name for the Level..."
			ERR_FILE_NOT_FOUND:
				$RenameLvl/Container/Error.bbcode_text = "[color=red]Whops, seems like the Level mentioned here doesn't exists..."
			ERR_ALREADY_EXISTS:
				$RenameLvl/Container/Error.bbcode_text = "[color=red]Ouch! Seems like there is already a Level with that id..."
			var id:
				$RenameLvl/Container/Error.bbcode_text = "[color=red]... Seems like we were not prepared for this type of error: " + String(id) + ". You should check out the docs."
		$RenameLvl/Container/Error.show()
		yield(get_tree().create_timer(4.0), "timeout")
		$RenameLvl/Container/Error.hide()
		return
	$RenameLvl.hide()

	print("Level renamed, renaming nodes...")
	level_nodes[HandyFunctions.snake_case(new_id)] = []
	print(level_nodes[HandyFunctions.snake_case(new_id)].size())

	for node_id in level_nodes[active_lvl].size():
		print("Node Id: " + String(node_id))
		print(level_nodes[active_lvl][0].name)
		level_nodes[active_lvl][0].title = new_id.capitalize()
		level_nodes[HandyFunctions.snake_case(new_id)].append(level_nodes[active_lvl][0])
		level_nodes[active_lvl].pop_front()

	level_nodes.erase(active_lvl)

	print("Updating...")
	update_levels()
	print("Done!")


func _on_level_edit_requested(level):
	print("Edit requested: " + level)


func _on_level_rename_requested(level):
	print("Rename requested: " + level)
	active_lvl = level
	$RenameLvl.window_title = "Rename Level %s?" % level.capitalize()
	$RenameLvl.popup()


func _on_level_delete_requested(level):
	print("Delete requested: " + level)
	active_lvl = level
	$DeleteLvl.window_title = "DELETE %s??" % level.capitalize()# Make the string 4 the popup window's title
	$DeleteLvl.popup()


func _on_level_add_requested(level: String):
	print("Node add requested: " + level)
	var lvl_node: GraphNode = $Tools/CenterPanel/Editors/MapEditor/HiddenNodes/LvlNode.duplicate(0) as GraphNode
	if typeof(level_nodes.get(level)) != TYPE_ARRAY:
		level_nodes[level] = []

	lvl_node.name = level + String(level_nodes[level].size())
	lvl_node.title = level.capitalize()
	$Tools/CenterPanel/Editors/MapEditor.add_child(lvl_node)
	lvl_node.connect("close_request", self, "_on_delete_node_request", [lvl_node, level])

	(level_nodes[level] as Array).append(lvl_node)


func _on_delete_node_request(level_node: GraphNode, level: String) -> void:
	print("Deleting Node: " + level_node.name)
	# This piece of code is optional, but prevents some connections to stay on screen (until other nodes are moved) even if the node is removed
	for connection in get_node("Tools/CenterPanel/Editors/MapEditor").get_connection_list():
		if connection.from == level_node.name or connection.to == level_node.name:
			$Tools/CenterPanel/Editors/MapEditor.disconnect_node(connection.from, connection.from_port, connection.to, connection.to_port)
	#
	(level_nodes[level] as Array).erase(level_node)
	print("Nodes found:")
	print(level_nodes)
	level_node.queue_free()
	print(level_node.is_queued_for_deletion())
	print("Node deleted succesfully!")


func _on_SidePanel_toggled(button_pressed: bool) -> void:
	$Tools/CenterPanel/SidePanel.visible = button_pressed


func _on_SizeBar_value_changed(value: float) -> void:
	for level in levels.keys():
		var lvl_thumbnail: TextureRect = get_node("Tools/CenterPanel/SidePanel/Levels/Levels/Container/" + level + "/Thumbnail")
		lvl_thumbnail.rect_min_size.y = value
		lvl_thumbnail.rect_size.y = value


func _on_MapEditor_connection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	$Tools/CenterPanel/Editors/MapEditor.connect_node(from, from_slot, to, to_slot)


func _on_MapEditor_disconnection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	$Tools/CenterPanel/Editors/MapEditor.disconnect_node(from, from_slot, to, to_slot)
