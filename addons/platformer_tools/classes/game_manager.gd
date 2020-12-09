tool
extends Node2D
# Not putting class_name because it's a Singleton, but it's GameManager

var levels := {}# All Levels go here
const DEFAULT_FOLDERS := {
	"levels": "res://world/levels",
	"worlds": "res://world/maps",
	"areas": "res://world/areas",
}# Folders used to store Levels, Areas and WorldMaps
const DEFAULT_DATA := {
	"tile_size": Vector2(8, 8),
	"chunk_size": 256,
}# Default data stored in each level


func load_level():# TODO: Load a Level as a scene
	pass


func update_levels(folders: Dictionary = DEFAULT_FOLDERS) -> Dictionary:
	levels.clear()
	var dir := Directory.new()# Scans every file in the level folder
	if dir.open(folders.levels) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()# From here starts the interesting code:
		while file_name != "":
			if dir.current_is_dir():
				pass# Don't care about directories
				#print("Found directory: " + file_name)
			else:
				if file_name.ends_with(".lvl"):# If it's a Level file
					var lvl := File.new()
					lvl.open(folders.levels + "/" + file_name, File.READ)
					levels[file_name.replace(".lvl", "")] = lvl.get_var(true)# Get what's inside the Level file (the class)
					lvl.close()
					print("Found Level: " + file_name.replace(".lvl", ""))
				else:
					print("Found file: " + file_name)# Care about files
			file_name = dir.get_next()
	else:
		print("The current level folder is not accessible, WHY??")# ERROR! (it doesn't update the Levels and it doen't retun an error, so be careful)
	print("Level(s) found:")
	print(levels)
	return levels.duplicate()


static func make_level(new_level_id: String, folders: Dictionary = DEFAULT_FOLDERS, data: Dictionary = DEFAULT_DATA, custom_data: Dictionary = {}) -> int:
	var snaked_id = HandyFunctions.snake_case(new_level_id)
	var level_file := File.new()
	var level_path: String = String(folders.levels + "/" + snaked_id + ".lvl")
	var level_data := Level.new()

	if new_level_id == "":
		print("ERROR! Must insert a name first")
		return ERR_INVALID_PARAMETER

	if level_file.file_exists(level_path):
		print("ERROR! The file at the path already exist!")
		return ERR_ALREADY_EXISTS

	if level_file.open(level_path, File.WRITE):
		var dir := Directory.new()
		dir.make_dir(folders.levels)
		level_file.open(level_path, File.WRITE)

	var dir := Directory.new()
	var err: int = dir.make_dir(folders.levels + "/" + snaked_id + "_chunks")
	if err:
		print("Whops, something wrong happened, error code: " + String(err))
		return err

	level_data.chunks_folder = folders.levels + "/" + snaked_id + "_chunks"
	level_data.tile_size = data.tile_size
	level_data.chunk_size = data.chunk_size
	level_data.custom_data = custom_data

	level_file.store_var(level_data, true)
	level_file.close()
	print("Level made succesfully!! :D")
	return OK


static func rename_level(old_id: String, new_id: String, folders: Dictionary = DEFAULT_FOLDERS):
	var snaked_new_id = HandyFunctions.snake_case(new_id)
	print("Renaming " + old_id.capitalize() + " to " + snaked_new_id.capitalize())
	var dir := Directory.new()

	if snaked_new_id == "":
		print("ERROR! Must insert a name first")
		return ERR_INVALID_PARAMETER

	if not dir.file_exists(folders.levels + "/" + snaked_new_id + ".lvl"):
		print("ERROR! There is already a level with that id!")
		return ERR_ALREADY_EXISTS

	if not dir.file_exists(folders.levels + "/" + old_id + ".lvl"):
		print("ERROR! Seems like the Level doesn't exists, so it cannot be renamed (bad id?)!")
		return ERR_FILE_NOT_FOUND

	var err1 = dir.rename(folders.levels + "/" + old_id + ".lvl", folders.levels + "/" + snaked_new_id + ".lvl")
	var err2 = dir.rename(folders.levels + "/" + old_id + "_chunks", folders.levels + "/" + snaked_new_id + "_chunks")
	if err1 or err2:
		print("Seems like something went wrong, here are the error codes: " + String(err1) + " and " + String(err2))
		return FAILED
	print("Success!!")
	return OK


static func delete_level(id: String, folders: Dictionary = DEFAULT_FOLDERS) -> int:
	print("Deleting " + id.capitalize() + "...")
	var dir := Directory.new()
	var err1 = dir.remove(folders.levels + "/" + id + ".lvl")
	var err2 = dir.remove(folders.levels + "/" + id + "_chunks")
	if err1 or err2:
		print("Seems like something went wrong, here are the error codes: " + String(err1) + " and " + String(err2))
		return FAILED
	print("Success!!")
	return OK


static func make_world(new_world_id: String, folders: Dictionary = DEFAULT_FOLDERS, custom_data: Dictionary = {}):# Warning: WIP (Work In Progress), DO NOT USE
	var snaked_id = HandyFunctions.snake_case(new_world_id)
	var world_file := File.new()
	var world_path: String = String(folders.worlds + "/" + snaked_id + ".map")
	var world_data := WorldMap.new()

	if new_world_id == "":
		print("ERROR! Must insert a name first")
		return ERR_INVALID_PARAMETER

	if world_file.file_exists(world_path):
		print("ERROR! The file at the path already exist!")
		return ERR_ALREADY_EXISTS

	if world_file.open(world_path, File.WRITE):
		var dir := Directory.new()
		dir.make_dir(folders.worlds)
		world_file.open(world_path, File.WRITE)


	world_file.store_var(world_data, true)
	world_file.close()
	print("world made succesfully!! :D")
