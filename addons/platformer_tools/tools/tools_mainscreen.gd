tool
extends Control


const default_options := {"level_folder": "res://levels",
		"level_defaults": {"tile_size": Vector2(8, 8), "chunk_size": 256},
		}
var options := {}
var levels := {}
var levels_ids := []


func _ready() -> void:
	$Tools/TopPanel/ToggleSidePanel.icon = get_icon("ArrowRight", "EditorIcons")
	options = default_options.duplicate()# Load default options
	
	var options_file := File.new()
	if options_file.open("user://platformer_tools/settings.set", File.READ) == OK:
		var file_options = options_file.get_var(true)# Read options from the filesys
		if file_options is Dictionary:
			for key in file_options.keys():
				options[key] = file_options[key]# Instance every user modification
	
	options_file.close()


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
	
	levels_ids.clear()
	print(levels_ids)
	for level in levels.keys():
		levels_ids.append(level)
	for node in get_tree().get_nodes_in_group("LevelSelection"):
		(node as OptionButton).clear()
		for level_id in levels_ids.size():
			(node as OptionButton).add_item((levels_ids[level_id] as String).capitalize(), level_id)
	print(levels_ids)


func _on_level_created() -> void:
	GameManager.make_level("Test", options)
	update_levels()


func _on_level_renamed() -> void:
	pass # Replace with function body.


func _on_level_deleted() -> void:
	pass # Replace with function body.


func _on_lvl_data_entry_created() -> void:
	pass # Replace with function body.


func _on_SidePanel_toggled(button_pressed: bool) -> void:
	$Tools/CenterPanel/SidePanel.visible = button_pressed
