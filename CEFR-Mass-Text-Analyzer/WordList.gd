extends Node


var WordList = []
var EntryList = []
var regex = RegEx.new()

func _ready():
	open_list()


func open_list():
	regex.compile("[a-z]+")
	var file = File.new()
	file.open("res://CEFRJWordlist", File.READ)
	while file.get_position() < file.get_len():
		var entry = file.get_csv_line()
		var splitEntry = entry[0].split("/")
		for word in splitEntry:
			EntryList.append([word, entry[1], entry[2]])
			word = word.to_lower()
			word = word.replace(".", "")
			word = regex.search(word).get_string()
			WordList.append(word)
	file.close()
