extends Node

var sfx_volume = 50
var music_volume = 10

# 0 - no save, 1- day 1, and so on 4 - room
var player_save = 0

func _ready() -> void:
	load_game()
	save_game([sfx_volume,music_volume,player_save])

func save_game(save_data):
	print("Saved to" + OS.get_data_dir())
	var save_file = FileAccess.open("user://okrim_save.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://okrim_save.save"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://okrim_save.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		json.parse(json_string)
		sfx_volume = json.data[0]
		music_volume = json.data[1]
		player_save = json.data[2]
