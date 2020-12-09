extends Resource
class_name Level, "res://addons/platformer_tools/classes/level_icon.svg"
# Level class, used to store stuff.

# Each Level has its own chunks, wich are used to load part of the levels without
# filling your entire memory with USELESS BULLSHIT
export var tile_size := Vector2(8, 8)
export var chunk_size := 64# Note that chunck_size is measured IN TILES, not in pixels
export var custom_data := {}

var chunks_folder: String = ""
var data: Dictionary# Where all the stuff goes
