tool
extends Control


const default_options := {"level_folder": "res://levels",
		"level_defaults": {"tile_size": Vector2(8, 8), "chunk_size": 256},
		}
var options := {}
var levels := {}


func _ready() -> void:
	options = default_options.duplicate()# Load default options
	
	var options_file := File.new()
	if options_file.open("user://platformer_tools/settings.set", File.READ) == OK:
		var file_options = options_file.get_var(true)# Read options from the filesys
		if file_options is Dictionary:
			for key in file_options.keys():
				options[key] = file_options[key]# Instance every user modification
	
	options_file.close()
	
	$Tools/Container/LevelFolder/Option.text = options.level_folder
	$Tools/Container/LevelDefault/Settings/TileSize/X.value = options.level_defaults.tile_size.x
	$Tools/Container/LevelDefault/Settings/TileSize/Y.value = options.level_defaults.tile_size.y
	$Tools/Container/LevelDefault/Settings/ChunkSize.value = options.level_defaults.chunk_size


func _on_settings_updated() -> void:
	options.level_folder = $Tools/Container/LevelFolder/Option.text if $Tools/Container/LevelFolder/Option.text != "" else default_options.level_folder
			# Only save if the option is modified
	options.level_defaults.tile_size = Vector2($Tools/Container/LevelDefault/Settings/TileSize/X.value,
			$Tools/Container/LevelDefault/Settings/TileSize/Y.value)
	options.level_defaults.chunk_size = $Tools/Container/LevelDefault/Settings/ChunkSize.value
	
	var options_file := File.new()
	if options_file.open("user://platformer_tools/settings.set", File.WRITE) != OK:# Make the saving dir if it doesn't exist
		var dir := Directory.new()
		dir.make_dir("user://platformer_tools")
		options_file.open("user://platformer_tools/settings.set", File.WRITE)
	
	options_file.store_var(options, true)
	options_file.close()


func update_levels():
	levels = GameManager.update_levels(options.level_folder)


func _on_level_created() -> void:
	GameManager.make_level($Tools/Container/NewLevel/Id.text, options)


func _on_level_renamed() -> void:
	pass # Replace with function body.


func _on_level_deleted() -> void:
	pass # Replace with function body.


func _on_lvl_data_entry_created() -> void:
	pass # Replace with function body.
