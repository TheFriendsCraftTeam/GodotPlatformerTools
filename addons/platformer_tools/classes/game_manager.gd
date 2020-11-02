tool
extends Node2D
#Not putting class_name because it's a Singleton, but it's GameManager


var levels := {}


func load_level():
	pass


func update_levels(level_folder: String) -> Dictionary:
	levels.clear()
	var dir := Directory.new()
	if dir.open(level_folder) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.ends_with(".lvl"):
					var lvl := File.new()
					lvl.open(level_folder + "/" + file_name, File.READ)
					levels[file_name.replace(".lvl", "")] = lvl.get_var(true)
					lvl.close()
					print("Found Level: " + file_name.replace(".lvl", ""))
				else:
					print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("The current level folder is not accessible, WHY??")
	print(levels)
	return levels.duplicate()


static func make_level(new_level_id: String, options: Dictionary, custom_data: Dictionary = {}):
	var snaked_id = HandyFunctions.snake_case(new_level_id)
	var level_file := File.new()
	var level_path: String = String(options.level_folder + "/" + snaked_id + ".lvl")
	var level_data := Level.new()
	
	if new_level_id == "":
		print("ERROR! Must insert a name first")
		return
	
	if level_file.file_exists(level_path):
		print("ERROR! The file at the path already exist!")
		return
	
	if level_file.open(level_path, File.WRITE):
		var dir := Directory.new()
		dir.make_dir(options.level_folder)
		level_file.open(level_path, File.WRITE)
	
	var dir := Directory.new()
	if dir.make_dir(options.level_folder + "/" + snaked_id + "_chunks"):
		print("OH SHIT, level_cunks Directory is NOT GOOD, retrying...")
		if dir.make_dir(options.level_folder + "/" + snaked_id + "_chunks"):
			print("NOPE, still an error we get, let's crash. :P")
			return
	
	level_data.chunks_folder = options.level_folder + "/" + snaked_id + "_chunks"
	level_data.tile_size = options.level_defaults.tile_size
	level_data.chunk_size = options.level_defaults.chunk_size
	level_data.custom_data = custom_data
	
	level_file.store_var(level_data, true)
	level_file.close()
	print("Level made succesfully!! :D")


static func make_world(new_world_id: String, options: Dictionary, custom_data: Dictionary = {}):
	var snaked_id = HandyFunctions.snake_case(new_world_id)
	var world_file := File.new()
	var world_path: String = String(options.world_folder + "/" + snaked_id + ".lvl")
	var world_data := WorldMap.new()
	
	if new_world_id == "":
		print("ERROR! Must insert a name first")
		return
	
	if world_file.file_exists(world_path):
		print("ERROR! The file at the path already exist!")
		return
	
	if world_file.open(world_path, File.WRITE):
		var dir := Directory.new()
		dir.make_dir(options.world_folder)
		world_file.open(world_path, File.WRITE)
	
	var dir := Directory.new()
	if dir.make_dir(options.world_folder + "/" + snaked_id + "_chunks"):
		print("OH SHIT, world_cunks Directory is NOT GOOD, retrying...")
		if dir.make_dir(options.world_folder + "/" + snaked_id + "_chunks"):
			print("NOPE, still an error we get, let's crash. :P")
			return
	
	world_data.chunks_folder = options.world_folder + "/" + snaked_id + "_chunks"
	world_data.tile_size = options.world_defaults.tile_size
	world_data.chunk_size = options.world_defaults.chunk_size
	world_data.custom_data = custom_data
	
	world_file.store_var(world_data, true)
	world_file.close()
	print("world made succesfully!! :D")


static func rename_level(old_id: String, new_id: String):
	pass
